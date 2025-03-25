class TabInfoModel {
  final TabInfo? tabInfo;
  final PgcInfo? pgcInfo;

  TabInfoModel({required this.tabInfo, required this.pgcInfo});

  factory TabInfoModel.fromJson(Map<String, dynamic> json) {
    return TabInfoModel(
      tabInfo:
          json['tabInfo'] != null ? TabInfo.fromJson(json['tabInfo']) : null,
      pgcInfo:
          json['pgcInfo'] != null ? PgcInfo.fromJson(json['pgcInfo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tabInfo != null) {
      data['tabInfo'] = tabInfo?.toJson();
    }
    if (pgcInfo != null) {
      data['pgcInfo'] = pgcInfo?.toJson();
    }
    return data;
  }
}

class TabInfo {
  final List<TabModel> tabList;
  final int defaultIdx;

  TabInfo({required this.tabList, required this.defaultIdx});

  factory TabInfo.fromJson(Map<String, dynamic> json) {
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

class PgcInfo {
  final String dataType;
  final int id;
  final String icon;
  final String name;
  final String brief;
  final String description;
  final String actionUrl;
  final String area;
  final String gender;
  final int registDate;
  final int followCount;
  final Follow? follow;
  final bool self;
  final String cover;
  final int videoCount;
  final int shareCount;
  final int collectCount;
  final int myFollowCount;
  final String videoCountActionUrl;
  final String myFollowCountActionUrl;
  final String followCountActionUrl;
  final String privateMessageActionUrl;
  final int medalsNum;
  final String medalsActionUrl;
  final String tagNameExport;
  final int worksRecCount;
  final int worksSelectedCount;
  final Shield? shield;
  final bool expert;

  PgcInfo({
    required this.dataType,
    required this.id,
    required this.icon,
    required this.name,
    required this.brief,
    required this.description,
    required this.actionUrl,
    required this.area,
    required this.gender,
    required this.registDate,
    required this.followCount,
    this.follow,
    required this.self,
    required this.cover,
    required this.videoCount,
    required this.shareCount,
    required this.collectCount,
    required this.myFollowCount,
    required this.videoCountActionUrl,
    required this.myFollowCountActionUrl,
    required this.followCountActionUrl,
    required this.privateMessageActionUrl,
    required this.medalsNum,
    required this.medalsActionUrl,
    required this.tagNameExport,
    required this.worksRecCount,
    required this.worksSelectedCount,
    this.shield,
    required this.expert,
  });

  factory PgcInfo.fromJson(Map<String, dynamic> json) {
    return PgcInfo(
      dataType: json['dataType'] ?? '',
      id: json['id'] ?? 0,
      icon: json['icon'] ?? '',
      name: json['name'] ?? '',
      brief: json['brief'] ?? '',
      description: json['description'] ?? '',
      actionUrl: json['actionUrl'] ?? '',
      area: json['area'] ?? '',
      gender: json['gender'] ?? '',
      registDate: json['registDate'] ?? 0,
      followCount: json['followCount'] ?? 0,
      follow: json['follow'] != null ? Follow.fromJson(json['follow']) : null,
      self: json['self'] ?? false,
      cover: json['cover'] ?? '',
      videoCount: json['videoCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      collectCount: json['collectCount'] ?? 0,
      myFollowCount: json['myFollowCount'] ?? 0,
      videoCountActionUrl: json['videoCountActionUrl'] ?? '',
      myFollowCountActionUrl: json['myFollowCountActionUrl'] ?? '',
      followCountActionUrl: json['followCountActionUrl'] ?? '',
      privateMessageActionUrl: json['privateMessageActionUrl'] ?? '',
      medalsNum: json['medalsNum'] ?? 0,
      medalsActionUrl: json['medalsActionUrl'] ?? '',
      tagNameExport: json['tagNameExport'] ?? '',
      worksRecCount: json['worksRecCount'] ?? 0,
      worksSelectedCount: json['worksSelectedCount'] ?? 0,
      shield: json['shield'] != null ? Shield.fromJson(json['shield']) : null,
      expert: json['expert'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dataType'] = dataType;
    data['id'] = id;
    data['icon'] = icon;
    data['name'] = name;
    data['brief'] = brief;
    data['description'] = description;
    data['actionUrl'] = actionUrl;
    data['area'] = area;
    data['gender'] = gender;
    data['registDate'] = registDate;
    data['followCount'] = followCount;
    if (follow != null) {
      data['follow'] = follow!.toJson();
    }
    data['self'] = self;
    data['cover'] = cover;
    data['videoCount'] = videoCount;
    data['shareCount'] = shareCount;
    data['collectCount'] = collectCount;
    data['myFollowCount'] = myFollowCount;
    data['videoCountActionUrl'] = videoCountActionUrl;
    data['myFollowCountActionUrl'] = myFollowCountActionUrl;
    data['followCountActionUrl'] = followCountActionUrl;
    data['privateMessageActionUrl'] = privateMessageActionUrl;
    data['medalsNum'] = medalsNum;
    data['medalsActionUrl'] = medalsActionUrl;
    data['tagNameExport'] = tagNameExport;
    data['worksRecCount'] = worksRecCount;
    data['worksSelectedCount'] = worksSelectedCount;
    if (shield != null) {
      data['shield'] = shield!.toJson();
    }
    data['expert'] = expert;
    return data;
  }
}

class Follow {
  final String itemType;
  final int itemId;
  final bool followed;

  Follow({
    required this.itemType,
    required this.itemId,
    required this.followed,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      itemType: json['itemType'] ?? '',
      itemId: json['itemId'] ?? 0,
      followed: json['followed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['itemType'] = itemType;
    data['itemId'] = itemId;
    data['followed'] = followed;
    return data;
  }
}

class Shield {
  final String itemType;
  final int itemId;
  final bool shielded;

  Shield({
    required this.itemType,
    required this.itemId,
    required this.shielded,
  });

  factory Shield.fromJson(Map<String, dynamic> json) {
    return Shield(
      itemType: json['itemType'] ?? '',
      itemId: json['itemId'] ?? 0,
      shielded: json['shielded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['itemType'] = itemType;
    data['itemId'] = itemId;
    data['shielded'] = shielded;
    return data;
  }
}
