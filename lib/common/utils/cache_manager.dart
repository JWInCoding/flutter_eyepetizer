import 'package:flutter_eyepetizer/common/utils/log_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  late SharedPreferences _preferences;

  // 私有构造函数
  CacheManager._();

  // 实现带参数的私有构造函数
  CacheManager._pre(SharedPreferences preferences) {
    _preferences = preferences;
  }

  static CacheManager? _instance;

  // 同步获取实例
  static CacheManager getInstance() {
    _instance ??= CacheManager._();
    return _instance!;
  }

  // 异步初始化
  static Future<CacheManager> preInit() async {
    if (_instance == null) {
      try {
        var preferences = await SharedPreferences.getInstance();
        _instance = CacheManager._pre(preferences);
      } catch (e) {
        _instance = CacheManager._();
        LogUtils.e('初始化 CacheManager 失败');
      }
    }
    return _instance!;
  }

  void set(String key, Object value) {
    if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is String) {
      _preferences.setString(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is List<String>) {
      _preferences.setStringList(key, value);
    } else {
      throw Exception("only Support int、String、double、bool、List<String>");
    }
  }

  T? get<T>(String key) {
    final value = _preferences.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }

  // 获取指定类型数据
  int? getInt(String key) => _preferences.getInt(key);
  String? getString(String key) => _preferences.getString(key);
  bool? getBool(String key) => _preferences.getBool(key);
  double? getDouble(String key) => _preferences.getDouble(key);
  List<String>? getStringList(String key) => _preferences.getStringList(key);

  // 检查键值是否存在
  bool containsKey(String key) => _preferences.containsKey(key);

  // 移除指定键值
  Future<bool> remove(String key) => _preferences.remove(key);

  // 清空所有键值
  Future<bool> clear() => _preferences.clear();
}
