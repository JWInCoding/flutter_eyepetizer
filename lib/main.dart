import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_eyepetizer/app_initialize.dart';
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
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
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

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.blueAccent,
        seedColor: Colors.lightBlue,
        brightness: Brightness.light,
        secondary: Colors.lightBlueAccent,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,

      // 卡片主题 - 根据图片效果优化
      cardTheme: CardTheme(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black12,
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
      ),

      // 应用栏主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // 标签栏主题
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),

      // 文本主题
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        titleMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
        bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
      ),

      // 分隔线主题
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 0.5,
        space: 0.5,
      ),

      // 图标主题
      iconTheme: const IconThemeData(color: Colors.black54, size: 24),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFEEEEEE)),
          ),
        ),
      ),

      // 输入装饰主题 (如搜索框等)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),

      // 芯片(标签)主题
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF5F5F5),
        labelStyle: const TextStyle(color: Colors.black87),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      scaffoldBackgroundColor: Colors.white,
    );
  }

  ThemeData _buildDarkTheme() {
    final Color cardBackgroundColor = Colors.grey[850]!;

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue,
        brightness: Brightness.dark,
        primary: Colors.lightBlueAccent,
        secondary: Colors.blueAccent,
        surface: cardBackgroundColor,
        onSurface: Colors.white,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,

      // 卡片主题 - 与亮色主题对应
      cardTheme: CardTheme(
        color: cardBackgroundColor,
        surfaceTintColor: cardBackgroundColor,
        shadowColor: Colors.black26,
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
      ),

      // 应用栏主题
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // 标签栏主题
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[500],
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),

      // 文本主题
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        bodySmall: TextStyle(color: Colors.white54, fontSize: 12),
      ),

      // 分隔线主题
      dividerTheme: DividerThemeData(
        color: Colors.grey[800]!,
        thickness: 0.5,
        space: 0.5,
      ),

      // 图标主题
      iconTheme: const IconThemeData(color: Colors.white70, size: 24),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[700]!),
          ),
        ),
      ),

      // 输入装饰主题 (如搜索框等)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),

      // 芯片(标签)主题
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[800]!,
        labelStyle: const TextStyle(color: Colors.white70),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      scaffoldBackgroundColor: Colors.grey[900],
    );
  }
}
