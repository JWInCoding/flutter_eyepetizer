import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_view_model.dart';
import 'package:lib_cache/cache_image.dart';
import 'package:lib_utils/date_utils.dart';
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

        return Container(
          // 背景
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CacheImage.provider(
                '${widget.videoData.cover.blurred}}/thumbnail/${MediaQuery.of(context).size.height}x${MediaQuery.of(context).size.width}',
              ),
            ),
          ),
          // 列表
          child: CustomScrollView(
            slivers: [_buildVideoInfo(), _buildItemList(viewModel)],
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _buildVideoInfo() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              widget.videoData.title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 类型、日期
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              '#${widget.videoData.category} / ${formatDateMsByYMDHM(widget.videoData.author.latestReleaseTime)}',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          // 简介
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              widget.videoData.description,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          //分割线
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(height: 0.5, color: Colors.white),
          ),
          // 作者、来源
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ClipOval(
                  child: CacheImage.network(
                    url:
                        widget.videoData.author.icon.isEmpty
                            ? widget.videoData.provider.icon
                            : widget.videoData.author.icon,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.videoData.author.name.isEmpty
                            ? widget.videoData.author.name
                            : widget.videoData.provider.name,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        widget.videoData.author.description,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 0.5, color: Colors.white),
        ],
      ),
    );
  }

  SliverList _buildItemList(VideoDetailViewModel viewModel) {
    return SliverList.builder(
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) {
        final item = viewModel.items[index];
        if (item.type == 'videoSmallCard') {
          return _buildCollectItem(context, item);
        } else if (item.data.text != null && item.data.text!.isNotEmpty) {
          return _buildTextItem(item);
        }
        return null;
      },
    );
  }

  Widget _buildTextItem(VideoItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
      child: Text(
        item.data.text!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCollectItem(BuildContext context, VideoItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Container(
        height: 80,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CacheImage.network(
                url: item.data.cover.feed,
                width: 130,
                height: double.infinity,
              ),
            ),
            Expanded(child: _buildMetadataRow(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context, VideoItem item) {
    final textColor = Colors.white.withValues(alpha: 0.9);

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.data.title,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${item.data.category} / ${item.data.author.name.isEmpty ? item.data.provider.name : item.data.author.name}',
                  style: TextStyle(color: textColor, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2),
              Text(
                formatDuration(item.data.duration),
                style: TextStyle(color: textColor, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
