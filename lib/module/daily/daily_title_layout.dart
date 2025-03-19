import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/module/daily/daily_model.dart';

class DailyTitleHeaderLayout extends StatelessWidget {
  const DailyTitleHeaderLayout(this.item, {super.key});

  final VideoItem item;

  @override
  Widget build(BuildContext context) {
    final textColorScheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Text(
        item.data.text ?? "",
        textAlign: TextAlign.center,
        style: textColorScheme.headlineSmall,
      ),
    );
  }
}
