import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/utils/toast_utils.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/videoList/video_list_builder.dart';
import 'package:flutter_eyepetizer/module/daily/daily_view_model.dart';
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
      appBar: appBar(
        context,
        'eyepetizer',
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        showBack: false,
        actions: [
          IconButton(
            onPressed: () {
              showTip('开发中');
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
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
                return VideoListBuilder.buildItem(
                  context,
                  viewModel.items[index],
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
