import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 刷新头部样式枚举
enum RefreshHeaderStyle {
  /// 经典样式
  classic,

  /// 水滴样式
  waterDrop,
}

class LocalizedSmartRefresher extends StatelessWidget {
  final RefreshController controller;
  final Widget child;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final bool enablePullDown;
  final bool enablePullUp;

  /// 刷新头部样式，默认为经典样式
  final RefreshHeaderStyle headerStyle;

  /// 水滴样式的颜色，仅在 headerStyle 为 waterDrop 时有效
  final Color? waterDropColor;

  const LocalizedSmartRefresher({
    super.key,
    required this.controller,
    required this.child,
    this.onRefresh,
    this.onLoading,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.headerStyle = RefreshHeaderStyle.classic,
    this.waterDropColor,
  });

  @override
  Widget build(BuildContext context) {
    // 获取本地化文本
    final l10n = AppLocalizations.of(context)!;

    // 根据选择的样式创建刷新头部
    final header = _buildLocalizedHeader(context, l10n);

    return SmartRefresher(
      controller: controller,
      onRefresh: onRefresh,
      onLoading: onLoading,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: header,
      footer:
          enablePullUp
              ? ClassicFooter(
                loadingText: l10n.loading,
                noDataText: l10n.noMoreData,
                idleText: l10n.loadMore,
              )
              : null,
      child: child,
    );
  }

  /// 创建本地化的刷新头部
  Widget _buildLocalizedHeader(BuildContext context, AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);

    switch (headerStyle) {
      case RefreshHeaderStyle.classic:
        return ClassicHeader(
          refreshingText: l10n.refreshing,
          completeText: l10n.refreshComplete,
          idleText: l10n.refreshPullDown,
          releaseText: l10n.refreshRelease,
          failedText: l10n.refreshFailed,
        );

      case RefreshHeaderStyle.waterDrop:
        return WaterDropHeader(
          // 水滴样式主要使用颜色和加载指示器，文本较少
          // 但仍然可以配置完成状态文本
          complete: Text(l10n.refreshComplete),
          refresh: Text(l10n.refreshing),
          // 可以使用传入的颜色或默认使用主题色
          waterDropColor: waterDropColor ?? theme.colorScheme.primary,
        );
    }
  }
}
