import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/module/author/author_page.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';

class VideoNavigation {
  // 跳转到视频详情页
  static void toVideoDetail(VideoData videoData) {
    toPage(
      () => VideoDetailPage(videoData: videoData),
      preventDuplicates: false,
    );
  }

  // 跳转到作者页面
  static void toAuthorPage(int authorId, String? authorIcon) {
    toPage(
      () => AuthorPage(authorId, authorIcon: authorIcon),
      preventDuplicates: false,
    );
  }
}
