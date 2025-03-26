import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/date_utils.dart';
import 'package:flutter_eyepetizer/common/widget/video_navigation.dart';

class VideoCollectionHorizontalScrollCard extends StatelessWidget {
  const VideoCollectionHorizontalScrollCard({super.key, required this.item});

  final VideoItem item;

  final _contentHeight = 260.0;

  // size 计算
  final _verticalPadding = 20.0;
  final _textAreaHeight = 45.0; // 增加文字区域高度
  // 图片可用高度
  double get _imageHeight =>
      _contentHeight - _verticalPadding - _textAreaHeight;

  // 使用16:9的视频标准宽高比
  final imageAspectRatio = 16 / 9;

  // 计算卡片宽度
  double get _cardWidth => _imageHeight * imageAspectRatio;

  @override
  Widget build(BuildContext context) {
    final nestedItems = item.data.itemList ?? [];
    if (nestedItems.isEmpty) return const SizedBox.shrink();

    final header = item.data.header;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),

        // 标题部分
        if (header != null && header.title.isNotEmpty)
          _buildHeader(context, header.title),

        // 滚动内容部分
        _buildScrollableContent(context, nestedItems),

        const Divider(height: 1),
      ],
    );
  }

  // 构建头部标题
  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // 构建可滚动内容区
  Widget _buildScrollableContent(BuildContext context, List<VideoItem> items) {
    return SizedBox(
      height: _contentHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return _buildPageItem(context, items[index]);
        },
      ),
    );
  }

  // 构建单个卡片项
  Widget _buildPageItem(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final textScheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        VideoNavigation.toVideoDetail(item.data);
      },
      child: Container(
        width: _cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片容器 - 带阴影效果
            Container(
              height: _imageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 缓存图片
                    CacheImage.network(
                      url: item.data.cover.feed,
                      fit: BoxFit.cover,
                    ),

                    // 添加渐变阴影，提高文字可读性
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 视频时长标签
                    if (item.data.duration > 0)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                              alpha: 0.6,
                            ), // 修正withValues为withOpacity
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            formatDuration(item.data.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 标题和日期
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatDateMsByYMDHM(item.data.releaseTime),
                    style: textScheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
