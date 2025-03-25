import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_list_builder.dart';
import 'package:flutter_eyepetizer/module/discovery/category/category_detail_view_model.dart';
import 'package:flutter_eyepetizer/module/discovery/category/category_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({
    super.key,
    required this.category,
    this.appbarBackgroundColor,
  });

  final CategoryModel category;
  final Color? appbarBackgroundColor;

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with BasePage<CategoryDetailPage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late final CategoryDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CategoryDetailViewModel(categoryId: widget.category.id);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    try {
      await _viewModel.refreshCategoryList();
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
    final appbarColor = widget.appbarBackgroundColor;
    final appbarForegroundColor = appbarColor != null ? Colors.white : null;
    return Scaffold(
      appBar: appBar(
        context,
        widget.category.description,
        centerTitle: false,
        foregroundColor: appbarForegroundColor,
        backgroundColor: appbarColor,
      ),
      body: Consumer<CategoryDetailViewModel>(
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
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: _buildContent(),
    );
  }
}
