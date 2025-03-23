import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/common/utils/request_util.dart';

import '../../../common/model/video_page_model.dart';

class HotListViewModel extends ChangeNotifier {
  final String apiUrl;

  List<VideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<VideoItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  HotListViewModel(this.apiUrl) {
    // 构造函数中可以立即执行初始加载
    loadHotData();
  }
  Future<void> loadHotData() async {
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    try {
      final response = await HttpGo.instance.get(
        apiUrl,
        fromJson: (json) => VideoPageResponseModel.fromJson(json),
      );
      if (response != null) {
        _items = _filterItems(response.itemList);
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
