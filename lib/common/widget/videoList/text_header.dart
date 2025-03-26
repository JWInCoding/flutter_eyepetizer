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
        Container(
          alignment: Alignment.center,
          height: 44,
          width: double.infinity,
          child: Text(
            item.data.text ?? "",
            textAlign: TextAlign.center,
            style: textColorScheme.titleLarge,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
