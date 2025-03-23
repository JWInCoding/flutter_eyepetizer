import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/utils/date_utils.dart';
import 'package:flutter_eyepetizer/common/utils/log_utils.dart';
import 'package:video_player/video_player.dart';

class VideoControllers extends StatefulWidget {
  const VideoControllers({
    super.key,
    this.showLoadingOnInitialize = true,
    required this.overlayUI,
    required this.bottomGradient,
    this.showBigPlayIcon = true,
  });

  final bool showLoadingOnInitialize;
  final bool showBigPlayIcon;
  final Widget overlayUI;
  final Gradient bottomGradient;

  @override
  State<VideoControllers> createState() => _VideoControllersState();
}

class _VideoControllersState extends State<VideoControllers>
    with SingleTickerProviderStateMixin {
  VideoPlayerValue? _latestValue;
  double _latestVolume = 0.5;
  bool _hideStuff = true;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;
  bool _wasFinished = false; // 标记视频是否从结束状态重新播放

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController? controller;
  ChewieController? chewieController;
  AnimationController? playPauseIconAnimationController;

  final Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    // 可以在这里做一些预初始化工作
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 确保在第一帧渲染后进行初始化
      _safeInitialize();
    });
  }

  void _safeInitialize() {
    try {
      final newChewieController = ChewieController.of(context);

      // 先检查是否已经初始化过
      if (chewieController == newChewieController &&
          controller == newChewieController.videoPlayerController &&
          playPauseIconAnimationController != null) {
        return; // 已经初始化过，不需要重复初始化
      }

      // 先清理旧资源
      _cleanupResources();

      chewieController = newChewieController;
      controller = chewieController!.videoPlayerController;

      // 如果动画控制器还没创建，才创建新的
      if (playPauseIconAnimationController == null ||
          !playPauseIconAnimationController!.isAnimating) {
        // 确保释放旧的控制器
        playPauseIconAnimationController?.dispose();

        playPauseIconAnimationController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 400),
        );
      }

      _initialize();
    } catch (e) {
      LogUtils.e('初始化视频控制器失败: $e');
    }
  }

  @override
  void dispose() {
    _cleanupResources();

    playPauseIconAnimationController?.dispose();

    // 移除对controller的监听
    controller?.removeListener(_updateState);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final oldController = chewieController;
    final newChewieController = ChewieController.of(context);

    // 只有当控制器真正发生变化时才重新初始化
    if (oldController != newChewieController) {
      // 临时存储旧值
      final oldAnimController = playPauseIconAnimationController;

      // 清理资源但不销毁动画控制器
      _cleanupResources();

      // 设置新控制器
      chewieController = newChewieController;
      controller = chewieController?.videoPlayerController;

      // 只在必要时创建新的动画控制器
      if (oldAnimController == null || !oldAnimController.isAnimating) {
        oldAnimController?.dispose();
        playPauseIconAnimationController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 400),
        );
      } else {
        playPauseIconAnimationController = oldAnimController;
      }

      _initialize();
    }

    super.didChangeDependencies();
  }

  void _cleanupResources() {
    // 仅处理监听器和计时器，不触及控制器销毁
    if (controller != null) {
      controller!.removeListener(_updateState);
    }
    _stopTimer();
  }

  Future<void> _initialize() async {
    // 先移除之前可能存在的监听器，避免重复
    controller?.removeListener(_updateState);

    // 添加新的监听器
    controller?.addListener(_updateState);

    // 立即更新一次状态
    _updateState();

    // 设置定时器
    if ((controller?.value.isPlaying ?? false) ||
        (chewieController?.autoPlay ?? false)) {
      _startHideTimer();

      // 如果是自动播放，确保图标状态与播放状态同步
      if (playPauseIconAnimationController != null &&
          (controller?.value.isPlaying ?? false)) {
        playPauseIconAnimationController!.forward();
      }
    }

    if (chewieController?.showControlsOnInitialize ?? false) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _hideStuff = false;
          });
        }
      });
    }
  }

  void _updateState() {
    if (!mounted) return;

    setState(() {
      _latestValue = controller?.value;

      // 根据播放状态更新动画控制器
      if (playPauseIconAnimationController != null && _latestValue != null) {
        if (_latestValue!.isPlaying) {
          playPauseIconAnimationController!.forward();
        } else {
          playPauseIconAnimationController!.reverse();
        }
      }
    });
  }

  void _pause() {
    if (_latestValue == null ||
        controller == null ||
        playPauseIconAnimationController == null) {
      return;
    }

    final isFinished = _latestValue!.position >= _latestValue!.duration;

    setState(() {
      if (controller!.value.isPlaying) {
        playPauseIconAnimationController!.reverse();
        _hideStuff = false;
        _hideTimer?.cancel();
        controller!.pause();
      } else {
        _resetTimer();
        if (isFinished) {
          controller!.seekTo(Duration.zero);
          // 添加一个标记表示我们刚从完成状态重新播放
          // 可以使用类变量保存这个状态
          _wasFinished = true;
        }
        playPauseIconAnimationController!.forward();
        controller!.play();
      }
    });
  }

  void _onExpandCollapse() {
    if (chewieController == null) return;

    setState(() {
      _hideStuff = true;
      chewieController!.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(_animationDuration, () {
        setState(() {
          _resetTimer();
        });
      });
    });
  }

  void _resetTimer() {
    _hideTimer?.cancel();
    _startHideTimer();
    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  void _stopTimer() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _initTimer?.cancel();
    _initTimer = null;
    _showAfterExpandCollapseTimer?.cancel();
    _showAfterExpandCollapseTimer = null;
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  /// UI

  Expanded _buildHitArea() {
    if (_latestValue == null) {
      return Expanded(child: Center(child: _loadingIndicator()));
    }

    bool isFinished = _latestValue!.position >= _latestValue!.duration;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_latestValue!.isPlaying) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else {
              _resetTimer();
            }
          } else {
            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity: !_latestValue!.isPlaying && !_dragging ? 1 : 0,
              duration:
                  _wasFinished ? Duration(seconds: 0) : _animationDuration,
              child: IgnorePointer(
                ignoring: _latestValue!.isPlaying,
                child:
                    widget.showBigPlayIcon
                        ? GestureDetector(
                          onTap: _pause,
                          child:
                              isFinished
                                  ? const Icon(
                                    Icons.replay_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                  : const Icon(
                                    Icons.play_circle_fill,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                        )
                        : const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _loadingIndicator() {
    return widget.showLoadingOnInitialize
        ? const CircularProgressIndicator()
        : null;
  }

  Widget _overlayUI() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _animationDuration,
      child: widget.overlayUI,
    );
  }

  GestureDetector _buildPlayAndPauseIcon(
    VideoPlayerController? videoController,
  ) {
    if (videoController == null) {
      return GestureDetector(onTap: () {}, child: const SizedBox());
    }

    return GestureDetector(
      onTap: _pause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Icon(
          videoController.value.isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(BuildContext context) {
    final iconColor = Colors.white;

    if (controller == null || chewieController == null) {
      return AnimatedOpacity(
        opacity: 0,
        duration: _animationDuration,
        child: Container(height: barHeight),
      );
    }

    return AnimatedOpacity(
      opacity: _hideStuff ? 0 : 1,
      duration: _animationDuration,
      child: Container(
        height: barHeight,
        decoration: BoxDecoration(gradient: widget.bottomGradient),
        child: Row(
          children: [
            _buildPlayAndPauseIcon(controller),
            if (chewieController?.isLive ?? false)
              const SizedBox()
            else
              _buildProgressBar(),

            if (chewieController?.isLive ?? false)
              const Expanded(child: Text('LIVE'))
            else
              _buildPosition(iconColor),

            if (chewieController?.allowPlaybackSpeedChanging ?? false)
              _buildSpeedButton(controller),

            if (chewieController?.allowMuting ?? false)
              _buildMuteButton(controller),
            if (chewieController?.allowFullScreen ?? false)
              _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    if (controller == null || chewieController == null) {
      return const Expanded(child: SizedBox());
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: MaterialVideoProgressBar(
          height: 2,
          barHeight: 2,
          handleHeight: 4,
          controller!,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });
            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });
            _startHideTimer();
          },
          colors:
              chewieController!.materialProgressColors ??
              ChewieProgressColors(
                playedColor: Colors.lightBlue,
                handleColor: Colors.lightBlue,
                bufferedColor: Colors.white,
                backgroundColor: Colors.white38,
              ),
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue?.position ?? Duration.zero;
    final duration = _latestValue?.duration ?? Duration.zero;

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        '${formatDuration(position.inSeconds)} / ${formatDuration(duration.inSeconds)}',
        style: TextStyle(fontSize: 12, color: iconColor),
      ),
    );
  }

  GestureDetector _buildMuteButton(VideoPlayerController? videoController) {
    if (videoController == null || _latestValue == null) {
      return GestureDetector(onTap: () {}, child: const SizedBox());
    }

    return GestureDetector(
      onTap: () {
        _resetTimer();
        if (_latestValue?.volume == 0) {
          videoController.setVolume(_latestVolume);
        } else {
          _latestVolume = videoController.value.volume;
          videoController.setVolume(0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0 : 1,
        duration: _animationDuration,
        child: ClipRRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Icon(
              (_latestValue != null && _latestValue!.volume > 0)
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedButton(VideoPlayerController? videoController) {
    if (videoController == null ||
        _latestValue == null ||
        chewieController == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () async {
        _hideTimer?.cancel();
        final chooseSpeed = await showModalBottomSheet<double>(
          context: context,
          builder:
              (context) => _PlaybackSpeedDialog(
                _latestValue!.playbackSpeed,
                chewieController!.playbackSpeeds,
              ),
        );

        if (chooseSpeed != null) {
          videoController.setPlaybackSpeed(chooseSpeed);
        }

        if (_latestValue?.isPlaying ?? false) {
          _startHideTimer();
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0 : 1,
        duration: _animationDuration,
        child: ClipRRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: const Icon(Icons.speed),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    if (chewieController == null) {
      return GestureDetector(onTap: () {}, child: const SizedBox());
    }

    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0 : 1,
        duration: _animationDuration,
        child: Container(
          height: barHeight,
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Center(
            child: Icon(
              chewieController!.isFullScreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 基本检查
    if (controller == null ||
        chewieController == null ||
        _latestValue == null) {
      return Center(
        child: _loadingIndicator() ?? const CircularProgressIndicator(),
      );
    }

    if (_latestValue!.hasError) {
      return chewieController!.errorBuilder != null
          ? chewieController!.errorBuilder!(
            context,
            controller!.value.errorDescription ?? '播放错误',
          )
          : const Center(
            child: Icon(Icons.error, color: Colors.white, size: 44),
          );
    }

    // 判断视频是否已播放完成
    bool isFinished = _latestValue!.position >= _latestValue!.duration;

    // 如果视频已经开始播放，重置_wasFinished标志
    if (_latestValue!.position > Duration.zero &&
        _latestValue!.position < _latestValue!.duration &&
        _wasFinished) {
      _wasFinished = false;
    }

    return MouseRegion(
      onHover: (event) {},
      child: GestureDetector(
        onTap: () => _resetTimer(),
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Stack(
            children: [
              Container(),
              Column(
                children: [
                  // 修改条件，避免在从完成状态重新播放且暂停时显示loading
                  if (!_latestValue!.isInitialized ||
                      (_latestValue!.isBuffering &&
                          !_latestValue!.isPlaying &&
                          !isFinished &&
                          !_wasFinished))
                    Expanded(
                      child: Center(
                        child:
                            _loadingIndicator() ??
                            const CircularProgressIndicator(),
                      ),
                    )
                  else
                    _buildHitArea(),

                  _buildBottomBar(context),
                ],
              ),
              _overlayUI(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaybackSpeedDialog extends StatelessWidget {
  const _PlaybackSpeedDialog(this._selected, this._speeds);

  final List<double> _speeds;
  final double _selected;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final speed = _speeds[index];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              if (speed == _selected)
                Icon(Icons.check, size: 20, color: selectedColor)
              else
                const SizedBox(width: 20),

              const SizedBox(width: 15),
              Text(speed.toString()),
            ],
          ),
          selected: speed == _selected,
          onTap: () {
            Navigator.of(context).pop(speed);
          },
        );
      },
      itemCount: _speeds.length,
    );
  }
}
