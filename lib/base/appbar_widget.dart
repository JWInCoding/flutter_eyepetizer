import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar appBar(
  BuildContext context,
  String title, {
  bool showBack = true,
  List<Widget>? actions,
}) {
  final appBarTheme = Theme.of(context).appBarTheme;
  final brightness = Theme.of(context).brightness;

  // 根据主题动态设置状态栏样式
  final SystemUiOverlayStyle systemUiOverlayStyle =
      brightness == Brightness.light
          ? const SystemUiOverlayStyle(
            // 浅色主题
            statusBarIconBrightness: Brightness.dark, // 状态栏图标黑色
            statusBarBrightness: Brightness.light, // iOS状态栏背景浅色
            statusBarColor: Colors.transparent, // Android状态栏透明
          )
          : const SystemUiOverlayStyle(
            // 深色主题
            statusBarIconBrightness: Brightness.light, // 状态栏图标白色
            statusBarBrightness: Brightness.dark, // iOS状态栏背景深色
            statusBarColor: Colors.transparent, // Android状态栏透明
          );

  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: appBarTheme.foregroundColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    systemOverlayStyle: systemUiOverlayStyle,
    centerTitle: true,
    elevation: 0,
    backgroundColor: appBarTheme.backgroundColor,
    leading: showBack ? BackButton(color: appBarTheme.foregroundColor) : null,
    actions: actions,
  );
}
