import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/module/author/author_page.dart';
import 'package:flutter_eyepetizer/module/playlist/play_list_page.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';

enum NavigationPageType {
  author, // 作者页面
  playlist, // 播放列表页面
}

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

  /// actionUrl 方式进行页面跳转
  static void actionUrl(String url, String iconUrl) {
    if (url.isEmpty) return;

    final result = parseActionUrl(url);

    // 如果解析结果为null，直接返回，不执行任何操作
    if (result == null) return;

    switch (result.pageType) {
      case NavigationPageType.author:
        VideoNavigation.toAuthorPage(int.parse(result.authorId!), iconUrl);
        break;
      case NavigationPageType.playlist:
        VideoNavigation.toPlayListPage(result.title, result.playlistUrl!);
        break;
    }
  }
}

/// URL解析结果
class ActionUrlResult {
  final NavigationPageType pageType;
  final String? authorId; // 作者ID
  final String? playlistUrl; // 播放列表URL
  final String title; // 页面标题

  ActionUrlResult({
    required this.pageType,
    this.authorId,
    this.playlistUrl,
    required this.title,
  });
}

ActionUrlResult? parseActionUrl(String urlString) {
  if (urlString.isEmpty) return null;

  Uri? uri;
  try {
    uri = Uri.parse(urlString);
  } catch (_) {
    return null;
  }

  // 非eyepetizer协议直接返回null
  if (uri.scheme != 'eyepetizer') return null;

  // 根据host直接判断页面类型
  switch (uri.host) {
    case 'pgc':
      // 先检查路径格式是否符合预期
      if (!uri.path.contains('/detail/')) return null;

      // 提取作者ID并验证
      final authorId = RegExp(r'/detail/(\d+)').firstMatch(uri.path)?.group(1);
      if (authorId == null || authorId.isEmpty) return null;

      return ActionUrlResult(
        pageType: NavigationPageType.author,
        authorId: authorId,
        title: '',
      );

    case 'common':
      // 提取播放列表URL并验证
      final playlistUrl = uri.queryParameters['url'];
      if (playlistUrl == null || playlistUrl.isEmpty) return null;

      final title = uri.queryParameters['title'] ?? '';

      return ActionUrlResult(
        pageType: NavigationPageType.playlist,
        playlistUrl: playlistUrl,
        title: title,
      );

    default:
      return null;
  }
}
