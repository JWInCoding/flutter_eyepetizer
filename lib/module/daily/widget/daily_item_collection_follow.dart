import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:lib_cache/lib_cache.dart';
import 'package:lib_utils/date_utils.dart';

class DailyItemCollectionFollow extends StatelessWidget {
  const DailyItemCollectionFollow({super.key, required this.item, this.onTap});

  final VideoItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 嵌套集合数据处理
    final nestedItems = item.data.itemList ?? [];
    if (nestedItems.isEmpty) return SizedBox();

    return Column(
      children: [
        const Divider(),
        GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                nestedItems
                    .map((item) => _buildCollectItem(context, item))
                    .toList(),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildCollectItem(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final shadowColor =
        theme.cardTheme.shadowColor ?? theme.colorScheme.surface;

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
      child: Container(
        height: 90,
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: shadowColor, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCover(context, item),
            Expanded(child: _buildInfo(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context, VideoItem item) {
    final playIconAlpha =
        Theme.of(context).brightness == Brightness.light ? 0.9 : 0.8;
    return Stack(
      alignment: Alignment.center,
      children: [
        CacheImage.network(
          url: item.data.cover.feed,
          width: 140,
          height: double.infinity,
        ),
        Icon(
          Icons.play_arrow,
          color: Colors.white.withValues(alpha: playIconAlpha),
          size: 30,
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final textScheme = theme.textTheme;
    final backgroundColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final bodyMediumColor = textScheme.bodyMedium?.color;

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.data.title,
            style: textScheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${item.data.category}',
                style: textScheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                formatDuration(item.data.duration),
                style: textScheme.bodySmall?.copyWith(color: bodyMediumColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
