import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/utils/cache_manager.dart';
import 'package:flutter_eyepetizer/common/utils/request_util.dart';
import 'package:flutter_eyepetizer/config/api.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AppInitialize {
  AppInitialize._();

  static Future<void> init() async {
    configDio(baseUrl: API.baseUrl);

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await CacheManager.preInit();

    Future.delayed(Duration(seconds: 1), () {
      FlutterNativeSplash.remove();
    });
  }
}
