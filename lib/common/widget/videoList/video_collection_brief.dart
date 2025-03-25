import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/date_utils.dart';

typedef VideoItemCallback = void Function(VideoItem videoItem);

class VideoCollectionBrief extends StatelessWidget {
  const VideoCollectionBrief({super.key, required this.item, this.onTap});

  final VideoItem item;
  final VideoItemCallback? onTap;

  // 调整内容高度，增加一些缓冲空间
  final _contentHeight = 280.0; // 增加了5像素的缓冲
  // size 计算
  final _verticalPadding = 40.0;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 确保对齐一致
      children: [
        _buildHeader(context, item),
        SizedBox(
          height: _contentHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nestedItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                return _buildPageItem(context, nestedItems[index]);
              },
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final textScheme = theme.textTheme;

    final header = item.data.header;
    if (header == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5), // 减少底部padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 确保垂直居中
        children: [
          ClipOval(
            child: CacheImage.network(
              url: header.icon,
              width: 40,
              height: 40,
            ), // 略微减小头像
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 使用最小空间
                children: [
                  Text(
                    header.title,
                    style: textScheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 限制为1行
                  ),
                  if (header.description.isNotEmpty)
                    Text(
                      header.description,
                      style: textScheme.bodyMedium, // 使用较小的文字样式
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final textScheme = theme.textTheme;

    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Container(
        width: _cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // 使用最小空间
          children: [
            // 图片容器
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
                    CacheImage.network(
                      url: item.data.cover.feed,
                      fit: BoxFit.cover,
                    ),
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
                            color: Colors.black.withValues(alpha: 0.6),
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

            // 标题和日期 - 优化布局
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 2), // 减少顶部padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 使用最小空间
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
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ), // 修正API
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
