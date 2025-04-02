import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/view_model.dart/page_list_view_model.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_list_builder.dart';
import 'package:provider/provider.dart';

class AuthorListPage extends StatefulWidget {
  const AuthorListPage({super.key, required this.apiUrl});

  final String apiUrl;

  @override
  State<AuthorListPage> createState() => _AuthorListPageState();
}

class _AuthorListPageState extends State<AuthorListPage>
    with BasePage<AuthorListPage>, AutomaticKeepAliveClientMixin {
  late final PageListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PageListViewModel(widget.apiUrl, [
      'video',
      'textHeader',
      'videoCollectionOfHorizontalScrollCard',
      'videoCollectionWithBrief',
    ]);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<PageListViewModel>(
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
  bool get wantKeepAlive => true;
}
