import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/common/utils/toast_utils.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_item_layout.dart';
import 'package:flutter_eyepetizer/module/daily/viewModel/daily_view_model.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_item_collection_cover.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_item_collection_follow.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_title_layout.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            // 使用SliverAppBar让内容可以滚动到顶部
            SliverAppBar(
              // 以下设置允许内容滚动到顶部边缘
              floating: true,
              pinned: false,
              snap: true,
              title: Text(
                'eyepetizer',
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontStyle: FontStyle.italic,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showTip('开发中');
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
          ];
        },
        body: Consumer<DailyViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.items.isEmpty) {
              if (viewModel.isLoading) {
                return const Center(child: AdaptiveProgressIndicator());
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
                  } else if (item.type == 'video') {
                    return VideoItemLayout(
                      item: item,
                      onTap: () {
                        toPage(() => VideoDetailPage(videoData: item.data));
                      },
                      onAuthorTap: () {
                        showTip('作者详情页开发中');
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            );
          },
        ),
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
