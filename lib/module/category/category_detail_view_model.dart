import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/model/video_page_model.dart';
import 'package:flutter_eyepetizer/config/api.dart';
import 'package:lib_net/lib_net.dart';

class CategoryDetailViewModel extends ChangeNotifier {
  final int categoryId;

  List<VideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _nextPageUrl;

  List<VideoItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _nextPageUrl == null ? false : true;

  final String deviceModel = (Platform.isAndroid ? 'Android' : 'iOS');

  CategoryDetailViewModel({required this.categoryId}) {
    refreshCategoryList();
  }

  Future<void> refreshCategoryList() async {
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    try {
      final response = await HttpGo.instance.get(
        API.categoryVideoList,
        queryParams: {
          'id': categoryId,
          'udid': API.udid,
          'deviceModel': deviceModel,
        },
        fromJson: (json) => VideoPageResponseModel.fromJson(json),
      );
      if (response != null) {
        _items = _filterItems(response.itemList);
        _nextPageUrl = response.nextPageUrl;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
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
        queryParams: {'udid': API.udid, 'deviceModel': deviceModel},
        fromJson: (json) => VideoPageResponseModel.fromJson(json),
      );
      if (response != null) {
        _items.addAll(_filterItems(response.itemList));
        _nextPageUrl = response.nextPageUrl;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<VideoItem> _filterItems(List<VideoItem> itemList) {
    List<VideoItem> items = [];
    items.addAll(itemList);

    items.removeWhere((item) {
      final saveType = item.type == 'video';

      return !saveType;
    });
    return items;
  }
}
