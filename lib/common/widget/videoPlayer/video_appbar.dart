import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/utils/view_utils.dart';

class VideoAppbar extends StatelessWidget {
  const VideoAppbar({super.key, this.onShareTap});

  final VoidCallback? onShareTap;

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
          IconButton(
            color: Colors.white,
            onPressed: onShareTap,
            icon: Icon(Icons.share, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
