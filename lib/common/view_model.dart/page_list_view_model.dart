import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/common/utils/request_util.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PageListViewModel extends ChangeNotifier {
  final String apiUrl;
  final Map<String, dynamic>? queryParams;
  final List<String> fliters;

  List<VideoItem> _itemList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _nextPageUrl;

  List<VideoItem> get itemList => _itemList;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _nextPageUrl == null ? false : true;

  PageListViewModel(this.apiUrl, this.fliters, {this.queryParams}) {
    // 构造函数中可以立即执行初始加载
    refreshListData();
  }

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> refreshListData() async {
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    try {
      final response = await HttpGo.instance.get(
        apiUrl,
        queryParams: queryParams,
        fromJson: (json) => VideoPageResponseModel.fromJson(json),
      );
      if (response != null) {
        _itemList = _filterItems(response.itemList);
        _nextPageUrl = response.nextPageUrl;
      }
      refreshController.refreshCompleted();
    } catch (e) {
      _hasError = true;
      refreshController.refreshFailed();
    } finally {
      _isLoading = false;
      notifyListeners();
      hasMore
          ? refreshController.loadComplete()
          : refreshController.loadNoData();
    }
  }

  Future<void> loadMoreData() async {
    if (_isLoading || _nextPageUrl == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await HttpGo.instance.get(
        _nextPageUrl!,
        queryParams: queryParams,
        fromJson: (json) => VideoPageResponseModel.fromJson(json),
      );
      if (response != null) {
        _itemList.addAll(_filterItems(response.itemList));
        _nextPageUrl = response.nextPageUrl;
      }
      hasMore
          ? refreshController.loadComplete()
          : refreshController.loadNoData();
    } catch (e) {
      _hasError = true;
      refreshController.loadFailed();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<VideoItem> _filterItems(List<VideoItem> itemList) {
    List<VideoItem> items = [];
    items.addAll(itemList);

    items.removeWhere((item) {
      final saveType = fliters.contains(item.type);

      return !saveType;
    });
    return items;
  }
}
