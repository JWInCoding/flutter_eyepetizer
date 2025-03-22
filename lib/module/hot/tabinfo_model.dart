class TabInfo {
  final List<TabModel> tabList;
  final int defaultIdx;

  TabInfo({required this.tabList, required this.defaultIdx});

  factory TabInfo.fromJson(Map<String, dynamic> json) {
    var tabInfoJson = json['tabInfo'] as Map<String, dynamic>?;

    // 处理整个响应结构有tabInfo字段的情况
    if (tabInfoJson != null) {
      return TabInfo(
        tabList:
            tabInfoJson['tabList'] != null
                ? List<TabModel>.from(
                  (tabInfoJson['tabList'] as List).map(
                    (item) => TabModel.fromJson(item),
                  ),
                )
                : [],
        defaultIdx: tabInfoJson['defaultIdx'] ?? 0,
      );
    }

    // 直接处理没有tabInfo嵌套的情况
    return TabInfo(
      tabList:
          json['tabList'] != null
              ? List<TabModel>.from(
                (json['tabList'] as List).map(
                  (item) => TabModel.fromJson(item),
                ),
              )
              : [],
      defaultIdx: json['defaultIdx'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tabList': tabList.map((tab) => tab.toJson()).toList(),
      'defaultIdx': defaultIdx,
    };
  }
}

class TabModel {
  final int id;
  final String name;
  final String apiUrl;
  final int tabType;
  final int nameType;
  final dynamic adTrack;

  TabModel({
    required this.id,
    required this.name,
    required this.apiUrl,
    required this.tabType,
    required this.nameType,
    this.adTrack,
  });

  factory TabModel.fromJson(Map<String, dynamic> json) {
    return TabModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      apiUrl: json['apiUrl'] ?? '',
      tabType: json['tabType'] ?? 0,
      nameType: json['nameType'] ?? 0,
      adTrack: json['adTrack'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'apiUrl': apiUrl,
      'tabType': tabType,
      'nameType': nameType,
      'adTrack': adTrack,
    };
  }
}
