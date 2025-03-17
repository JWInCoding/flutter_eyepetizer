import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'package:get/get.dart';

void toPage(Widget page, {bool opaque = false, preventDuplicates = true}) {
  Get.to(() => page, opaque: opaque, preventDuplicates: preventDuplicates);
}

void offPage(Widget page, {bool opaque = false}) {
  Get.off(() => page, opaque: opaque);
}

void toNamed(String page, dynamic argument, {preventDuplicates = true}) {
  Get.toNamed(page, preventDuplicates: preventDuplicates, arguments: argument);
}

void offNamed(String page, dynamic arguments, {preventDuplicates = true}) {
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
