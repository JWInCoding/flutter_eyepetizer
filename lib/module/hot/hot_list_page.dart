import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_item_layout.dart';
import 'package:flutter_eyepetizer/module/hot/hot_list_view_model.dart';
import 'package:flutter_eyepetizer/module/videoDetail/video_detail_page.dart';
import 'package:lib_navigator/lib_navigator.dart';
import 'package:lib_utils/toast_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HotListPage extends StatefulWidget {
  const HotListPage({super.key, required this.apiUrl});

  final String apiUrl;

  @override
  State<HotListPage> createState() => _HotListPageState();
}

class _HotListPageState extends State<HotListPage>
    with BasePage<HotListPage>, AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late final HotListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HotListViewModel(widget.apiUrl);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await _viewModel.loadHotData();
    if (_viewModel.hasError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<HotListViewModel>(
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
            headerStyle: RefreshHeaderStyle.waterDrop,
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];

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
  bool get wantKeepAlive => true;
}
