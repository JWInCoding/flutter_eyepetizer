import 'package:flutter/material.dart';
import 'package:lib_utils/lib_utils.dart';

class VideoAppbar extends StatelessWidget {
  const VideoAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: BackButton(color: Colors.white),
          ),
          Row(
            children: [
              Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
