import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lib_cache/lib_cache.dart';
import 'package:lib_net/lib_net.dart';

class AppInitialize {
  AppInitialize._();

  static Future<void> init() async {
    configDio(baseUrl: 'https://baobab.kaiyanapp.com/api/');

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await CacheManager.preInit();

    Future.delayed(Duration(seconds: 1), () {
      FlutterNativeSplash.remove();
    });
  }
}
