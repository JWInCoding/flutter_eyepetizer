import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/module/author/author_page.dart';
import 'package:flutter_eyepetizer/module/playlist/play_list_page.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';

class VideoNavigation {
  /// 跳转到视频详情页
  static void toVideoDetail(VideoData videoData) {
    toPage(
      () => VideoDetailPage(videoData: videoData),
      preventDuplicates: false,
    );
  }

  /// 跳转到作者页面
  static void toAuthorPage(int authorId, String? authorIcon) {
    toPage(
      () => AuthorPage(authorId, authorIcon: authorIcon),
      preventDuplicates: false,
    );
  }

  /// 跳转到播放列表页面
  static void toPlayListPage(String playListName, String apiUrl) {
    toPage(() => PlayListPage(playListName: playListName, apiUrl: apiUrl));
  }

  /// 从actionUrl解析参数并跳转到播放列表页面
  ///
  /// [actionUrlString] 格式如："eyepetizer://common/?title=xxx&url=xxx"
  /// 返回布尔值表示是否成功解析并跳转
  static bool toPlayListPageFromActionUrl(String actionUrlString) {
    if (actionUrlString.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(actionUrlString);

      final title = uri.queryParameters['title'];
      final url = uri.queryParameters['url'];

      if (title != null && url != null) {
        toPlayListPage(title, url);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
