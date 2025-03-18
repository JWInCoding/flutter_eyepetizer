import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/config/Api.dart';
import 'package:flutter_eyepetizer/module/daily/daily_model.dart';
import 'package:lib_net/lib_net.dart';

class DailyViewModel extends ChangeNotifier {
  List<VideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _nextPageUrl;

  List<VideoItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _nextPageUrl == null ? false : true;

  Future<void> refreshDailyData() async {
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    try {
      final response = await HttpGo.instance.get(
        Api.dailyFirstPage,
        fromJson: (json) => DailyResponseModel.fromJson(json),
      );
      if (response != null) {
        _items = response.itemList;
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
        fromJson: (json) => DailyResponseModel.fromJson(json),
      );
      if (response != null) {
        _items.addAll(response.itemList);
        _nextPageUrl = response.nextPageUrl;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
