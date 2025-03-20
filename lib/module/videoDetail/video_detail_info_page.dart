import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_view_model.dart';
import 'package:provider/provider.dart';

class VideoDetailInfoPage extends StatefulWidget {
  const VideoDetailInfoPage({super.key, required this.videoData});

  final VideoData videoData;

  @override
  State<VideoDetailInfoPage> createState() => _VideoDetailInfoPageState();
}

class _VideoDetailInfoPageState extends State<VideoDetailInfoPage>
    with BasePage<VideoDetailInfoPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoDetailViewModel(videoId: widget.videoData.id),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Consumer<VideoDetailViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.items.isEmpty) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.hasError) {
            return RetryWidget(onTapRetry: viewModel.refreshDetailData);
          }
          return const EmptyWidget();
        }

        // 正确返回列表项
        return ListView.builder(
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            final item = viewModel.items[index];
            // 注意这里使用了return语句返回ListTile
            return ListTile(title: Text(item.data.title));
          },
        );
      },
    );
  }
}
