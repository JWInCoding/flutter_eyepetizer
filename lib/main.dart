import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_eyepetizer/app_initialize.dart';
import 'package:flutter_eyepetizer/config/theme.dart';
import 'package:flutter_eyepetizer/main_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lib_navigator/lib_navigator.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('zh');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppInitialize.init(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        return GetMaterialApp(
          title: 'eyepetzier',
          themeMode: ThemeMode.system,
          theme: ThemeManager.lightTheme(),
          darkTheme: ThemeManager.darkTheme(),
          home: const MainPage(),
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: AppLocalizations.supportedLocales,
          // 本地化代理
          localizationsDelegates: const [
            AppLocalizations.delegate, // 自动生成的本地化代理
            GlobalMaterialLocalizations.delegate, // Material 组件本地化
            GlobalWidgetsLocalizations.delegate, // 基础 Widget 本地化
            GlobalCupertinoLocalizations.delegate, // Cupertino 组件本地化
          ],
        );
      },
    );
  }
}
