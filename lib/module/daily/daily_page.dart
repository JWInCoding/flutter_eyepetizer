import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/view_model.dart/page_list_view_model.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_list_builder.dart';
import 'package:flutter_eyepetizer/config/Api.dart';
import 'package:provider/provider.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});
  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage>
    with BasePage<DailyPage>, AutomaticKeepAliveClientMixin {
  late final PageListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PageListViewModel(API.dailyFirstPage, [
      'video',
      'textHeader',
      'videoCollectionWithCover',
      'videoCollectionOfFollow',
    ]);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
      ),
      body: Consumer<PageListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.itemList.isEmpty) {
            if (viewModel.isLoading) {
              return const Center(child: AdaptiveProgressIndicator());
            }
            if (viewModel.hasError) {
              return RetryWidget(onTapRetry: viewModel.refreshListData);
            }
            return const EmptyWidget();
          }

          return LocalizedSmartRefresher(
            controller: viewModel.refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: viewModel.refreshListData,
            onLoading: viewModel.loadMoreData,
            child: ListView.builder(
              itemCount: viewModel.itemList.length,
              itemBuilder: (context, index) {
                return VideoListBuilder.buildItem(
                  context,
                  viewModel.itemList[index],
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
