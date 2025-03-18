import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

appBar(
  BuildContext context,
  String title, {
  bool showBack = true,
  List<Widget>? actions,
}) {
  final appBarTheme = Theme.of(context).appBarTheme;
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: appBarTheme.foregroundColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    systemOverlayStyle: SystemUiOverlayStyle(),
    centerTitle: true,
    elevation: 0,
    backgroundColor: appBarTheme.backgroundColor,
    leading: showBack ? BackButton(color: appBarTheme.foregroundColor) : null,
    actions: actions,
  );
}
