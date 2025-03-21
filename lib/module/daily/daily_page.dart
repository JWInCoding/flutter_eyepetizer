import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_item_layout.dart';
import 'package:flutter_eyepetizer/module/daily/viewModel/daily_view_model.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_item_collection_cover.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_item_collection_follow.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_title_layout.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';
import 'package:lib_navigator/lib_navigator.dart';
import 'package:lib_utils/lib_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});
  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage>
    with BasePage<DailyPage>, AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late final DailyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DailyViewModel();
    // 初始化时加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.refreshDailyData();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await _viewModel.refreshDailyData();
    if (_viewModel.hasError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
    if (_viewModel.hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  void _onLoadMore() async {
    await _viewModel.loadMoreData();
    if (_viewModel.hasError) {
      _refreshController.loadFailed();
    } else {
      if (_viewModel.hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }
  }

  Widget _buildContent() {
    return Scaffold(
      appBar: appBar(
        context,
        '日报',
        showBack: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showTip('开发中');
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),
      body: Consumer<DailyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.items.isEmpty) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.hasError) {
              return RetryWidget(onTapRetry: _onRefresh);
            }
            return const EmptyWidget();
          }

          return LocalizedSmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            headerStyle: RefreshHeaderStyle.waterDrop,
            onRefresh: _onRefresh,
            onLoading: _onLoadMore,
            child: ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];

                if (item.type == 'textHeader') {
                  return DailyTitleHeaderLayout(item);
                } else if (item.type == 'videoCollectionWithCover') {
                  return DailyItemCollectionCover(
                    item: item,
                    onTap: (tapItem) {
                      toPage(() => VideoDetailPage(videoData: tapItem.data));
                    },
                  );
                } else if (item.type == 'videoCollectionOfFollow') {
                  return DailyItemCollectionFollow(
                    item: item,
                    onTap: (tapItem) {
                      toPage(() => VideoDetailPage(videoData: tapItem.data));
                    },
                  );
                } else if (item.type == 'squareCardCollection') {
                  return DailyItemCollectionFollow(
                    item: item,
                    onTap: (tapItem) {
                      toPage(() => VideoDetailPage(videoData: tapItem.data));
                    },
                  );
                }

                return VideoItemLayout(
                  item: item,
                  onTap: () {
                    toPage(() => VideoDetailPage(videoData: item.data));
                  },
                  onAuthorTap: () {
                    showTip('作者详情页开发中');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: _buildContent(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
