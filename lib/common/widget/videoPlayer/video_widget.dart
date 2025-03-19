import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_utils/lib_utils.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
    this.looping = false,
    this.allowFullScreen = true,
    this.allowPlaybackSpeedChanging = false,
    this.aspectRatio = 16 / 9,
    required this.overlayUI,
  });

  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedChanging;
  final double aspectRatio;
  final Widget overlayUI;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();

    // 设置初始方向为竖屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initializePlayer() async {
    try {
      // 创建视频控制器
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      // 等待初始化完成
      await _videoPlayerController!.initialize();

      // 只有在组件仍然挂载时才创建ChewieController
      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: widget.autoPlay,
          looping: widget.looping,
          aspectRatio: widget.aspectRatio,
          allowFullScreen: widget.allowFullScreen,
          allowPlaybackSpeedChanging: widget.allowPlaybackSpeedChanging,
        );

        // 添加全屏监听器
        _chewieController!.addListener(_fullScreenListener);

        // 更新UI
        setState(() {});
      }
    } catch (e) {
      LogUtils.e("视频初始化错误: $e");
    }
  }

  // 修改后的全屏监听器 - 强制竖屏
  void _fullScreenListener() {
    if (_chewieController == null) return;

    final bool isFullScreen = _chewieController!.isFullScreen;

    if (isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = isFullScreen;
      });

      // 检测屏幕方向，如果是横屏，强制回到竖屏
      final size = MediaQuery.of(context).size;
      if (size.width > size.height) {
        // 强制回到竖屏
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        // 还可以调整UI显示模式
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  @override
  void dispose() {
    // 恢复方向设置
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 移除监听器
    _chewieController?.removeListener(_fullScreenListener);

    // 释放资源
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    super.dispose();
  }

  void play() {
    _chewieController?.play();
  }

  void pause() {
    _chewieController?.pause();
  }

  @override
  Widget build(BuildContext context) {
    // 如果播放器未初始化
    if (_chewieController == null ||
        !(_videoPlayerController?.value.isInitialized ?? false)) {
      return const SizedBox();
    }

    // 简化后的布局 - 不需要考虑横屏情况，因为我们总是强制竖屏
    double width = MediaQuery.of(context).size.width;
    double height = width / widget.aspectRatio;

    return SizedBox(
      width: width,
      height: height,
      child: Chewie(controller: _chewieController!),
    );
  }
}
