import 'package:logger/logger.dart';

class LogUtils {
  static const String logTag = 'eyepetizer';

  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1, // 显示的方法调用数量
      errorMethodCount: 5, // 错误情况下显示的方法调用数量
      lineLength: 80, // 每行长度
      colors: true, // 启用颜色
      printEmojis: true, // 打印表情符号
    ),
  );

  static String _getTimestamp() {
    DateTime now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  // 打印 info 日志
  static void i(String msg) {
    String timestamp = _getTimestamp();
    logger.i("[$timestamp][$logTag] $msg");
  }

  // 打印 debug 日志
  static void d(String msg) {
    String timestamp = _getTimestamp();
    logger.d("[$timestamp][$logTag] $msg");
  }

  // 打印警告日志
  static void w(String msg) {
    String timestamp = _getTimestamp();
    logger.w("[$timestamp][$logTag] $msg");
  }

  // 打印错误日志
  static void e(String msg) {
    String timestamp = _getTimestamp();
    logger.e("[$timestamp][$logTag] $msg");
  }
}
