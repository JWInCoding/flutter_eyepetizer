import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/module/daily/widget/daily_item_collection_follow.dart';
import 'package:flutter_eyepetizer/module/follow/viewModel/follow_view_model.dart';
import 'package:flutter_eyepetizer/module/follow/widget/follow_collection.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';
import 'package:lib_navigator/lib_navigator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with BasePage<FollowPage>, AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late final FollowViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FollowViewModel();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    try {
      await _viewModel.refreshFollowData();
      _refreshController.refreshCompleted();
      _viewModel.hasMore
          ? _refreshController.loadComplete()
          : _refreshController.loadNoData();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoadMore() async {
    try {
      await _viewModel.loadMoreData();
      _viewModel.hasMore
          ? _refreshController.loadComplete()
          : _refreshController.loadNoData();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Widget _buildContent() {
    return SafeArea(
      bottom: false,
      child: Consumer<FollowViewModel>(
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

                if (item.type == 'videoCollectionWithBrief') {
                  return FollowCollection(
                    item: item,
                    onTap: (tapItem) {
                      toPage(() => VideoDetailPage(videoData: tapItem.data));
                    },
                  );
                } else if (item.type ==
                    'videoCollectionOfHorizontalScrollCard') {
                  return DailyItemCollectionFollow(
                    item: item,
                    onTap: (tapItem) {
                      toPage(() => VideoDetailPage(videoData: tapItem.data));
                    },
                  );
                }

                return const SizedBox.shrink();
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
