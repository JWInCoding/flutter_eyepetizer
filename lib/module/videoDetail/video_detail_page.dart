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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            _statusBar(),
            VideoWidget(
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
            ),
            Expanded(
              flex: 1,
              child: VideoDetailInfoPage(
                videoData: videodata,
                onItemListTap: (videoItem) {
                  videoKey.currentState?.pause();
                  VideoNavigation.toVideoDetail(videoItem.data);
                },
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
