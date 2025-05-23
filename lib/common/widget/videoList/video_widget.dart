import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/date_utils.dart';
import 'package:flutter_eyepetizer/common/widget/video_navigation.dart';

class VideoWidget extends StatelessWidget {
  // 类常量定义
  static const double kAvatarSize = 44.0;
  static const double kIconSize = 44.0;
  static const double kSmallIconSize = 14.0;
  static const EdgeInsets kInfoPadding = EdgeInsets.fromLTRB(15, 10, 15, 10);

  const VideoWidget({super.key, required this.item, this.showCategory = true});

  final VideoItem item;
  final bool showCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildCover(context, item), _buildInfo(context, item)],
    );
  }

  GestureDetector _buildCover(BuildContext context, VideoItem item) {
    final size = MediaQuery.of(context).size;
    final coverHeight = size.width / 16 * 9;
    final playIconAlpha =
        Theme.of(context).brightness == Brightness.light ? 1.0 : 0.8;

    return GestureDetector(
      onTap: () {
        VideoNavigation.toVideoDetail(item.data);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CacheImage.network(
            url: item.data.cover.feed,
            width: size.width,
            height: coverHeight,
          ),
          Icon(
            Icons.play_arrow,
            color: Colors.white.withValues(alpha: playIconAlpha),
            size: kIconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, VideoItem item) {
    final theme = Theme.of(context);
    final textScheme = theme.textTheme;
    final backgroundColor = theme.cardTheme.color ?? theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      padding: kInfoPadding,
      child: Row(
        children: [
          _buildAuthorAvatar(context, item),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.data.title,
                    style: textScheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: _buildMetadataRow(context, item),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorAvatar(BuildContext context, VideoItem item) {
    final avatarUrl =
        item.data.author.icon.isEmpty
            ? item.data.provider.icon
            : item.data.author.icon;

    return GestureDetector(
      onTap: () {
        VideoNavigation.toAuthorPage(item.data.author.id, avatarUrl);
      },
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: CacheImage.network(
          url: avatarUrl,
          width: kAvatarSize,
          height: kAvatarSize,
        ),
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context, VideoItem item) {
    final textScheme = Theme.of(context).textTheme;
    final bodyMediumColor = textScheme.bodyMedium?.color;

    return Row(
      children: [
        Text(item.data.author.name, style: textScheme.bodySmall),
        const SizedBox(width: 10),
        if (showCategory) ...[
          Text('#${item.data.category}', style: textScheme.bodySmall),
          const SizedBox(width: 20),
        ],
        Icon(Icons.play_arrow, color: bodyMediumColor, size: kSmallIconSize),
        const SizedBox(width: 2),
        Text(
          formatDuration(item.data.duration),
          style: textScheme.bodySmall?.copyWith(color: bodyMediumColor),
        ),
      ],
    );
  }
}
