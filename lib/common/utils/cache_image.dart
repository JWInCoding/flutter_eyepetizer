import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';

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
              loadingWidget ??
              _buildPlaceholderWidget(
                backgroundColor,
                width: width,
                height: height,
              ),
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
  /// 创建加载中Widget - 动态计算指示器大小
  static Widget _buildPlaceholderWidget(
    Color? backgroundColor, {
    double? width,
    double? height,
  }) {
    // 计算适当的指示器大小
    double indicatorSize = 10.0; // 默认最小尺寸

    if (width != null && height != null && height != double.infinity) {
      // 如果同时提供了宽高且高度不是无限，取较小值的1/4
      indicatorSize = (width < height ? width : height) / 4;
    } else if (width != null) {
      // 只有宽度有效，使用宽度的1/5
      indicatorSize = width / 5;
    } else if (height != null && height != double.infinity) {
      // 只有高度有效且不是无限，使用高度的1/4
      indicatorSize = height / 4;
    }

    // 限制在合理范围内(10~40)
    indicatorSize = indicatorSize.clamp(10.0, 40.0);

    return Container(
      color: backgroundColor ?? _defaultPlaceholderColor,
      child: Center(child: AdaptiveProgressIndicator(size: indicatorSize)),
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
