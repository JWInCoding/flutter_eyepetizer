import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_list_builder.dart';
import 'package:flutter_eyepetizer/module/playlist/play_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({
    super.key,
    required this.playListName,
    required this.apiUrl,
  });

  final String playListName;
  final String apiUrl;

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>
    with BasePage<PlayListPage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late final PlayListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PlayListViewModel(widget.apiUrl);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await _viewModel.refreshListData();
    if (_viewModel.hasError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: appBar(context, widget.playListName),
        body: Consumer<PlayListViewModel>(
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
      ),
    );
  }
}
