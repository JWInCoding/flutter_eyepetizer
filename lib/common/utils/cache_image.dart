import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage {
  /// 私有构造函数，防止实例化
  CacheImage._();

  /// 默认占位图背景颜色
  static final Color _defaultPlaceholderColor = Colors.grey[500]!;

  /// 默认图片淡入动画时长
  static const Duration _defaultFadeInDuration = Duration(milliseconds: 100);

  static Widget network({
    required String url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? loadingWidget,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Duration? fadeInDuration,
    int? memCacheHeight,
    int? memCacheWidth,
    int? maxHeightDiskCache,
    int? maxWidthDiskCache,
  }) {
    if (url.isEmpty) {
      return _buildErrorWidget(errorWidget, backgroundColor);
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      fadeInDuration: fadeInDuration ?? _defaultFadeInDuration,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      placeholder:
          (context, url) =>
              loadingWidget ?? _buildPlaceholderWidget(backgroundColor),
      errorWidget:
          (context, url, error) =>
              errorWidget ?? _buildErrorWidget(null, backgroundColor),
    );

    return _applyBorderRadius(imageWidget, borderRadius);
  }

  /// 获取网络图片的ImageProvider
  static ImageProvider provider(String url, {Map<String, String>? headers}) {
    return CachedNetworkImageProvider(url, headers: headers);
  }

  /// 预加载网络图片
  static Future<void> preload(String url, BuildContext context) async {
    try {
      await precacheImage(
        provider(url),
        context,
        onError: (exception, stackTrace) {
          debugPrint('图片预加载失败: $url\n错误: $exception');
        },
      );
    } catch (e) {
      debugPrint('预加载异常: ${e.toString()}');
    }
  }

  /// 清除特定URL的图片缓存
  static Future<void> clearCache(String url) async {
    await CachedNetworkImage.evictFromCache(url);
  }

  // MARK: - 私有辅助方法

  /// 创建加载中Widget - Material风格
  static Widget _buildPlaceholderWidget(Color? backgroundColor) {
    return Container(
      color: backgroundColor ?? _defaultPlaceholderColor,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  /// 创建错误Widget - Material风格
  static Widget _buildErrorWidget(
    Widget? customWidget,
    Color? backgroundColor,
  ) {
    return customWidget ??
        Container(
          color: backgroundColor ?? _defaultPlaceholderColor,
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.red),
          ),
        );
  }

  /// 应用圆角
  static Widget _applyBorderRadius(Widget widget, BorderRadius? borderRadius) {
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: widget);
    }
    return widget;
  }
}
