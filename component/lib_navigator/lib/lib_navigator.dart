import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'package:get/get.dart';

// 避免直接传递 Widget 实例，改为传递构建函数
void toPage(
  Widget Function() page, {
  bool opaque = false,
  bool preventDuplicates = true,
}) {
  Get.to(page, opaque: opaque, preventDuplicates: preventDuplicates);
}

void offPage(Widget Function() page, {bool opaque = false}) {
  Get.off(page, opaque: opaque);
}

// 其他方法保持不变
void toNamed(String page, dynamic argument, {bool preventDuplicates = true}) {
  Get.toNamed(page, preventDuplicates: preventDuplicates, arguments: argument);
}

void offNamed(String page, dynamic arguments, {bool preventDuplicates = true}) {
  Get.offNamed(
    page,
    preventDuplicates: preventDuplicates,
    arguments: arguments,
  );
}

void offAndToNamed(String page, dynamic arguments) {
  Get.offAndToNamed(page, arguments: arguments);
}

void back() {
  Get.back();
}

dynamic arguments() {
  return Get.arguments;
}
