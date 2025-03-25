import 'package:flutter/material.dart';

class AuthorTabbarDelegate extends SliverPersistentHeaderDelegate {
  const AuthorTabbarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.transparent, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
