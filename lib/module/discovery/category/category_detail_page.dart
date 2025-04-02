import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/view_model.dart/page_list_view_model.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/common/widget/localized_smart_refresher.dart';
import 'package:flutter_eyepetizer/common/widget/video_list_builder.dart';
import 'package:flutter_eyepetizer/config/Api.dart';
import 'package:flutter_eyepetizer/module/discovery/category/category_model.dart';
import 'package:provider/provider.dart';

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
  late final PageListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final String deviceModel = (Platform.isAndroid ? 'Android' : 'iOS');
    _viewModel = PageListViewModel(
      API.categoryVideoList,
      ['video'],
      queryParams: {
        'id': widget.category.id,
        'udid': API.udid,
        'deviceModel': deviceModel,
      },
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: _buildContent(),
    );
  }
}
