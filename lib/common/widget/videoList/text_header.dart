import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';

class TextHeader extends StatelessWidget {
  const TextHeader(this.item, {super.key});

  final VideoItem item;

  @override
  Widget build(BuildContext context) {
    final textColorScheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            item.data.text ?? "",
            textAlign: TextAlign.center,
            style: textColorScheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}
