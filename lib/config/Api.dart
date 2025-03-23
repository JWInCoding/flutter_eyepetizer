class API {
  /// 使用固定的 udid，否则服务器可能验证失败
  static const String udid = 'd2807c895f0348a180148c9dfa6f2feeac0781b5';

  /// 首页文章
  static const String dailyFirstPage = "v4/tabs/selected";

  /// 视频详情页中的视频列表
  static const String videoRelateUrl = 'v4/video/related?id=';

  /// 热门标签
  static const String rankList = 'v4/rankList';

  /// 分类列表
  static const String categoryList = 'v4/categories';

  /// 分类视频列表
  static const String categoryVideoList = 'v4/categories/videoList';

  /// 关注
  static const String follow = 'v4/tabs/follow';
}
