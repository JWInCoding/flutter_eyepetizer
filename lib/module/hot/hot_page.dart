import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/utils/request_util.dart';
import 'package:flutter_eyepetizer/common/utils/toast_utils.dart';
import 'package:flutter_eyepetizer/config/Api.dart';
import 'package:flutter_eyepetizer/module/hot/hot_list_page.dart';
import 'package:flutter_eyepetizer/module/hot/tabinfo_model.dart';

class HotPage extends StatefulWidget {
  const HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage>
    with
        BasePage<HotPage>,
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  List<TabModel> _tabList = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _loadHotTabs();
  }

  void _loadHotTabs() async {
    try {
      TabInfo? response = await HttpGo.instance.get(
        API.rankList,
        fromJson: (json) => TabInfo.fromJson(json),
      );

      setState(() {
        _tabList = response!.tabList;
        _isLoading = false;
        // 在数据加载完成后初始化TabController
        _tabController = TabController(length: _tabList.length, vsync: this);
      });
    } catch (e) {
      showTip(e.toString());
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: Center(child: CircularProgressIndicator())),
      );
    }
    if (_hasError) {
      return RetryWidget(onTapRetry: _loadHotTabs);
    }
    if (_tabList.isEmpty) {
      return EmptyWidget();
    }

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
          tabAlignment: TabAlignment.start,
          dividerHeight: 0,
          isScrollable: true,
          tabs: _tabList.map((e) => Tab(text: e.name)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabList.map((e) => HotListPage(apiUrl: e.apiUrl)).toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
