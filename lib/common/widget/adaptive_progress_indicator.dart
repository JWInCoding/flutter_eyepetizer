import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  final double? size;
  final Color? color; // 通用颜色
  final Color? iosColor; // iOS专用颜色
  final Color? androidColor; // Android专用颜色
  final double? strokeWidth;
  final double? value;
  final bool isIndeterminate;

  const AdaptiveProgressIndicator({
    super.key,
    this.size,
    this.color,
    this.iosColor,
    this.androidColor,
    this.strokeWidth,
    this.value,
    this.isIndeterminate = true,
  });

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    // 计算平台特定尺寸
    final double effectiveSize = size ?? 30.0;

    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // iOS平台颜色优先级：iosColor > color > null
        final effectiveColor = iosColor ?? color;

        if (effectiveColor != null) {
          // 使用ColorFiltered包装
          return SizedBox(
            width: effectiveSize,
            height: effectiveSize,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcATop),
              child: CupertinoActivityIndicator(radius: effectiveSize / 2),
            ),
          );
        } else {
          return CupertinoActivityIndicator(radius: effectiveSize / 2);
        }
      default:
        // Android平台颜色优先级：androidColor > color > null
        final effectiveColor = androidColor ?? color;

        return SizedBox(
          height: effectiveSize,
          width: effectiveSize,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth ?? 4.0,
            color: effectiveColor,
            value: isIndeterminate ? null : value,
          ),
        );
    }
  }
}
