import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/date_utils.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_view_model.dart';
import 'package:provider/provider.dart';

typedef VideoItemCallback = void Function(VideoItem videoItem);

class VideoDetailInfoPage extends StatefulWidget {
  const VideoDetailInfoPage({
    super.key,
    required this.videoData,
    this.onItemListTap,
  });

  final VideoData videoData;

  final VideoItemCallback? onItemListTap;

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
    // 创建图片提供者
    final imageProvider = CacheImage.provider(widget.videoData.cover.blurred);
    return FutureBuilder(
      future: precacheImage(imageProvider, context),
      builder: (context, snapshot) {
        // 如果图片正在加载，显示占位加载指示器
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          // 背景 - 此时图片已经缓存
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
            color: Colors.black87,
          ),
          child: CustomScrollView(
            slivers: [
              _buildVideoInfo(),
              Consumer<VideoDetailViewModel>(
                builder: (context, viewModel, _) {
                  return _buildRelateVideoContent(viewModel);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 当前视频信息
  SliverToBoxAdapter _buildVideoInfo() {
    final titlePgc =
        widget.videoData.titlePgc.isEmpty
            ? widget.videoData.category
            : widget.videoData.titlePgc;

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
              '#$titlePgc   ${formatDateMsByYMDHM(widget.videoData.author.latestReleaseTime)}',
              style: TextStyle(color: Colors.white60, fontSize: 12),
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
                            ? widget.videoData.provider.name
                            : widget.videoData.author.name,
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

  /// 相关视频列表
  /// 相关视频列表
  Widget _buildRelateVideoContent(VideoDetailViewModel viewModel) {
    // 如果正在加载且没有数据，显示居中的加载指示器
    if (viewModel.isLoading && viewModel.items.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 错误处理
    if (viewModel.hasError && viewModel.items.isEmpty) {
      return SliverFillRemaining(
        child: RetryWidget(onTapRetry: viewModel.refreshDetailData),
      );
    }

    // 空数据处理
    if (!viewModel.isLoading && viewModel.items.isEmpty) {
      return SliverFillRemaining(child: const EmptyWidget());
    }

    // 有数据时渲染列表
    return SliverList.builder(
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) {
        return _buildItemList(viewModel, index);
      },
    );
  }

  /// 相关视频列表
  Widget _buildItemList(VideoDetailViewModel viewModel, int index) {
    final item = viewModel.items[index];
    if (item.type == 'videoSmallCard') {
      return _buildCollectItem(context, item);
    } else if (item.data.text != null && item.data.text!.isNotEmpty) {
      return _buildTextItem(item);
    }
    return SizedBox.shrink();
  }

  /// 相关视频列表标题
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

  /// 相关视频列表 item
  Widget _buildCollectItem(BuildContext context, VideoItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: GestureDetector(
        onTap: () => widget.onItemListTap?.call(item),
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
      ),
    );
  }

  /// 相关视频 item 的视频信息
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
