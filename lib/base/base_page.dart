import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/config/string.dart';

mixin BasePage<T extends StatefulWidget> on State<T> {
  /// 是否正在显示 loading
  bool showLoading = false;

  showLoadingDialog() async {
    if (showLoading) {
      return;
    }
    showLoading = true;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdaptiveProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(loadingText),
              ),
            ],
          ),
        );
      },
    );
  }

  dismissLoading() {
    if (showLoading) {
      Navigator.of(context).pop();
    }
  }
}

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key, required this.onTapRetry});

  final void Function() onTapRetry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapRetry,
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Icon(Icons.refresh),
            ),
            Text(reloadAgain),
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Icon(Icons.book),
          ),
          Text(emptyTip),
        ],
      ),
    );
  }
}
