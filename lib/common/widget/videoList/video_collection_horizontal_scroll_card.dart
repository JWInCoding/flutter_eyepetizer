import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/date_utils.dart';

typedef VideoItemCallback = void Function(VideoItem videoItem);

class VideoCollectionHorizontalScrollCard extends StatelessWidget {
  const VideoCollectionHorizontalScrollCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final VideoItem item;
  final VideoItemCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 嵌套集合数据处理
    final nestedItems = item.data.itemList ?? [];
    if (nestedItems.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nestedItems.length,
              padding: EdgeInsets.symmetric(horizontal: 10), // 统一外边距控制
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

  Widget _buildPageItem(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final textScheme = theme.textTheme;
    final cardWidth = MediaQuery.of(context).size.width * 0.9 - 10;

    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Container(
        width: cardWidth, // 预计算宽度
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            CacheImage.network(url: item.data.cover.feed, fit: BoxFit.cover),

            // 底部渐变效果
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),

            // 只对底部区域应用模糊效果 - 更高效
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 60, // 只模糊底部文字区域
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 3.0, // 降低模糊强度以提高性能
                    sigmaY: 3.0,
                  ),
                  child: Container(color: Colors.transparent), // 空容器，不会占用额外资源
                ),
              ),
            ),

            // 底部文字信息
            Positioned(
              left: 15,
              right: 15,
              bottom: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min, // 减少布局计算
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.data.title,
                    style: textScheme.bodySmall?.copyWith(color: Colors.white),
                    maxLines: 1, // 限制行数提高性能
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${item.data.category}',
                        style: textScheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            formatDuration(item.data.duration),
                            style: textScheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
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
