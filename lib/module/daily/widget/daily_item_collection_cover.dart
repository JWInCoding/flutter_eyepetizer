import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';

typedef VideoItemCallback = void Function(VideoItem videoItem);

class DailyItemCollectionCover extends StatelessWidget {
  const DailyItemCollectionCover({super.key, required this.item, this.onTap});

  final VideoItem item;
  final VideoItemCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 嵌套集合数据处理
    final nestedItems = item.data.itemList ?? [];
    if (nestedItems.isEmpty) return SizedBox();

    final PageController controller = PageController(
      viewportFraction: 0.9, // 这个值控制每个页面占视口的比例，小于1会显示相邻页面
    );

    return Column(
      children: [
        const Divider(),
        SizedBox(
          height: 220,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: PageView.builder(
              controller: controller,
              itemCount: nestedItems.length,
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
    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            CacheImage.network(url: item.data.cover.feed),

            // 底部区域的模糊效果
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 50, // 增加高度以覆盖文字区域
              child: ClipRect(
                // 关键：添加ClipRect来限制模糊范围
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0, // 减小模糊强度
                    sigmaY: 5.0,
                    tileMode: TileMode.decal,
                  ),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

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
                    stops: [0.6, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 5,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.data.title,
                    style: textScheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    '#${item.data.category}',
                    style: textScheme.titleMedium?.copyWith(
                      color: Colors.white,
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
