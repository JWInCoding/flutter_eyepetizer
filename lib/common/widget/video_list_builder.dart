import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/text_header.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/video_collection_brief.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/video_collection_cover.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/video_collection_follow.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/video_collection_horizontal_scroll_card.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/video_widget.dart';
import 'package:flutter_eyepetizer/module/author/author_page.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';

/// 视频列表构建器，提供构建列表项的逻辑
class VideoListBuilder {
  /// 构建列表项
  static Widget buildItem(BuildContext context, VideoItem item) {
    if (item.type == 'textHeader') {
      return TextHeader(item);
    } else if (item.type == 'videoCollectionWithCover') {
      return VideoCollectionCover(
        item: item,
        onTap: (tapItem) {
          toPage(() => VideoDetailPage(videoData: tapItem.data));
        },
      );
    } else if (item.type == 'videoCollectionOfFollow' ||
        item.type == 'squareCardCollection') {
      return VideoCollectionFollow(
        item: item,
        onTap: (tapItem) {
          toPage(() => VideoDetailPage(videoData: tapItem.data));
        },
      );
    } else if (item.type == 'video') {
      return VideoWidget(
        item: item,
        onTap: () {
          toPage(() => VideoDetailPage(videoData: item.data));
        },
        onAuthorTap: () {
          toPage(() => AuthorPage(author: item.data.author));
        },
      );
    } else if (item.type == 'videoCollectionWithBrief') {
      return VideoCollectionBrief(item: item);
    } else if (item.type == 'videoCollectionOfHorizontalScrollCard') {
      return VideoCollectionHorizontalScrollCard(item: item);
    }
    return SizedBox.shrink();
  }
}
