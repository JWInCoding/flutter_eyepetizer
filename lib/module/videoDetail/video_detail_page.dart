import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/widget/videoPlayer/video_appbar.dart';
import 'package:flutter_eyepetizer/common/widget/videoPlayer/video_widget.dart';
import 'package:flutter_eyepetizer/module/daily/model/daily_model.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key, required this.videoData});

  final VideoData videoData;

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _statusBar(),
          Hero(
            tag: '${widget.videoData.id}${widget.videoData.time}',
            child: VideoWidget(
              videoUrl: widget.videoData.playUrl,
              overlayUI: VideoAppbar(),
            ),
          ),
        ],
      ),
    );
  }

  _statusBar() {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: Colors.black,
    );
  }
}
