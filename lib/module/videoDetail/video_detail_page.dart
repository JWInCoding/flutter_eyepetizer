import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/share_utils.dart';
import 'package:flutter_eyepetizer/common/widget/videoPlayer/video_appbar.dart';
import 'package:flutter_eyepetizer/common/widget/videoPlayer/video_widget.dart';
import 'package:flutter_eyepetizer/common/widget/video_navigation.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_info_page.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key, required this.videoData});

  final VideoData videoData;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with WidgetsBindingObserver {
  final GlobalKey<VideoWidgetState> videoKey = GlobalKey();

  late VideoData videodata;

  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();

    videodata = widget.videoData;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      videoKey.currentState?.pause();
    } else if (state == AppLifecycleState.resumed) {
      videoKey.currentState?.play();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final statusBarHeight = mediaQuery.padding.top;

    // 计算视频高度（非全屏状态）
    final videoHeight = screenWidth / 16 * 9; // 假设比例为16:9

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // 黑色背景，确保全屏时没有白色闪烁
            Container(color: Colors.black),

            // 状态栏区域（只在非全屏时可见）
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: statusBarHeight,
              child: _isFullScreen ? const SizedBox.shrink() : _statusBar(),
            ),

            // 视频播放器
            Positioned(
              top: _isFullScreen ? 0 : statusBarHeight,
              left: 0,
              right: 0,
              height: _isFullScreen ? screenHeight : videoHeight,
              child: VideoWidget(
                key: videoKey,
                videoUrl: widget.videoData.playUrl,
                overlayUI: VideoAppbar(
                  onShareTap: () {
                    share(
                      widget.videoData.title,
                      widget.videoData.webUrl.forWeibo,
                    );
                  },
                ),
                onFullScreenChanged: (isFullScreen) {
                  setState(() {
                    _isFullScreen = isFullScreen;
                  });
                },
              ),
            ),

            // 详情信息页
            Positioned(
              top:
                  _isFullScreen
                      ? screenHeight
                      : statusBarHeight + videoHeight, // 全屏时移出屏幕
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black,
                child: VideoDetailInfoPage(
                  videoData: videodata,
                  onItemListTap: (videoItem) {
                    videoKey.currentState?.pause();
                    VideoNavigation.toVideoDetail(videoItem.data);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBar() {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: Colors.black,
    );
  }
}
