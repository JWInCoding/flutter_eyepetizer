import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/module/discovery/category/category_page.dart';
import 'package:flutter_eyepetizer/module/discovery/follow/follow_page.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _tabs = ['关注', '分类'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tabBarTheme = Theme.of(context).tabBarTheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: tabBarTheme.labelColor,
          unselectedLabelColor: tabBarTheme.unselectedLabelColor,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: tabBarTheme.indicatorColor!,
              width: 2,
            ),
          ),
          indicatorPadding: EdgeInsets.only(bottom: 5.0),
          tabAlignment: TabAlignment.start,
          dividerHeight: 0,
          isScrollable: true,
          tabs: _tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [FollowPage(), CategoryPage()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
