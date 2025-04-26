import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/model/tabinfo_model.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/common/utils/request_util.dart';
import 'package:flutter_eyepetizer/common/utils/toast_utils.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/config/api.dart';
import 'package:flutter_eyepetizer/module/author/author_list_page.dart';
import 'package:flutter_eyepetizer/module/author/author_tabbar_delegate.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage(this.authorId, {super.key, this.authorIcon});

  final int authorId;
  final String? authorIcon;

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage>
    with BasePage<AuthorPage>, TickerProviderStateMixin {
  // 数据相关
  bool _isLoading = true;
  bool _hasError = false;
  List<TabModel> _tabList = [];
  late PgcInfo _pgcInfo;

  // 页面相关
  TabController? _tabController;
  ScrollController? _scrollController;

  bool get _isShrink =>
      _scrollController!.hasClients &&
      _scrollController!.offset > (200 - kToolbarHeight);
  //记录SliverAppBar上一次的状态
  bool _sliverAppBarLastStatus = true;

  void _loadTabs() async {
    try {
      TabInfoModel? response = await HttpGo.instance.get(
        API.authorTabList,
        queryParams: {'id': widget.authorId, 'udid': API.udid},
        fromJson: (json) => TabInfoModel.fromJson(json),
      );

      setState(() {
        if (response != null && response.pgcInfo != null) {
          _tabList = response.tabInfo?.tabList ?? [];
          _pgcInfo = response.pgcInfo!;
          // 在数据加载完成后初始化TabController
          _tabController = TabController(length: _tabList.length, vsync: this);
          _scrollController = ScrollController();
          _scrollController?.addListener(_scrollListener);
        } else {
          _hasError = true;
        }

        _isLoading = false;
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
  void initState() {
    super.initState();
    _loadTabs();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isShrink != _sliverAppBarLastStatus) {
      setState(() {
        _sliverAppBarLastStatus = _isShrink;
      });
    }
  }

  Widget _buildSliverAppBar() {
    final appBarTheme = Theme.of(context).appBarTheme;
    return SliverAppBar(
      expandedHeight: 200,
      elevation: 0,
      pinned: true,
      backgroundColor: appBarTheme.backgroundColor,
      leading: IconButton(
        onPressed: () => back(),
        icon: Icon(
          Icons.arrow_back,
          color: _isShrink ? appBarTheme.foregroundColor : Colors.white,
        ),
      ),
      title: Text(
        _pgcInfo.name,
        style: TextStyle(
          color: _isShrink ? appBarTheme.foregroundColor : Colors.white,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/default_header_bg.png'),
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: CacheImage.network(
                      url: widget.authorIcon ?? _pgcInfo.icon,
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        _pgcInfo.description,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoWidget(
                      '作品',
                      formatNumberWithUnit(_pgcInfo.videoCount),
                    ),
                    _buildInfoWidget(
                      '关注',
                      formatNumberWithUnit(_pgcInfo.followCount),
                    ),
                    _buildInfoWidget(
                      '分享',
                      formatNumberWithUnit(_pgcInfo.shareCount),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlverPersistentHeader() {
    final tabBarTheme = Theme.of(context).tabBarTheme;
    return SliverPersistentHeader(
      pinned: true,
      delegate: AuthorTabbarDelegate(
        tabBar: TabBar(
          controller: _tabController,
          labelColor: tabBarTheme.labelColor,
          unselectedLabelColor: tabBarTheme.unselectedLabelColor,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: tabBarTheme.indicatorColor!,
              width: 2,
            ),
          ),
          indicatorPadding: EdgeInsets.only(top: 5.0),
          tabAlignment: TabAlignment.fill,
          dividerHeight: 0,
          isScrollable: false,
          tabs:
              _tabList.map((e) {
                return Tab(text: e.name);
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoWidget(String title, String count) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  /// 格式化数字，大于万时用w表示并保留一位小数
  String formatNumberWithUnit(int number) {
    // 如果数字大于等于一万，转换为"w"单位
    if (number >= 10000) {
      // 除以10000并保留一位小数
      double result = number / 10000;
      return '${result.toStringAsFixed(1)}w';
    }

    // 小于一万的数字直接返回
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: Center(child: AdaptiveProgressIndicator())),
      );
    }
    if (_hasError) {
      return Scaffold(body: RetryWidget(onTapRetry: _loadTabs));
    }
    if (_tabList.isEmpty) {
      return const Scaffold(body: EmptyWidget());
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[_buildSliverAppBar(), _buildSlverPersistentHeader()];
        },
        body: TabBarView(
          controller: _tabController,
          children:
              _tabList.map((e) => AuthorListPage(apiUrl: e.apiUrl)).toList(),
        ),
      ),
    );
  }
}
