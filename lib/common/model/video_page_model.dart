class VideoPageResponseModel {
  final int count;
  final int total;
  final String? nextPageUrl;
  final bool adExist;
  final int date;
  final int nextPublishTime;
  final int refreshCount;
  final int lastStartId;
  final List<VideoItem> itemList;

  // 新增字段
  final int publishTime;
  final int releaseTime;
  final String type;

  VideoPageResponseModel({
    required this.count,
    required this.total,
    this.nextPageUrl,
    required this.adExist,
    required this.date,
    required this.nextPublishTime,
    required this.refreshCount,
    required this.lastStartId,
    required this.itemList,
    this.publishTime = 0,
    this.releaseTime = 0,
    this.type = '',
  });

  factory VideoPageResponseModel.fromJson(Map<String, dynamic> json) {
    return VideoPageResponseModel(
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
      nextPageUrl: json['nextPageUrl'],
      adExist: json['adExist'] ?? false,
      date: json['date'] ?? 0,
      nextPublishTime: json['nextPublishTime'] ?? 0,
      refreshCount: json['refreshCount'] ?? 0,
      lastStartId: json['lastStartId'] ?? 0,
      // 新增字段解析
      publishTime: json['publishTime'] ?? 0,
      releaseTime: json['releaseTime'] ?? 0,
      type: json['type'] ?? '',
      itemList:
          (json['itemList'] as List?)
              ?.map(
                (item) =>
                    item != null
                        ? VideoItem.fromJson(
                          item is Map<String, dynamic> ? item : {},
                        )
                        : VideoItem.empty(),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total': total,
      'nextPageUrl': nextPageUrl,
      'adExist': adExist,
      'date': date,
      'nextPublishTime': nextPublishTime,
      'refreshCount': refreshCount,
      'lastStartId': lastStartId,
      'itemList': itemList.map((item) => item.toJson()).toList(),
      'publishTime': publishTime,
      'releaseTime': releaseTime,
      'type': type,
    };
  }

  factory VideoPageResponseModel.empty() {
    return VideoPageResponseModel(
      count: 0,
      total: 0,
      nextPageUrl: null,
      adExist: false,
      date: 0,
      nextPublishTime: 0,
      refreshCount: 0,
      lastStartId: 0,
      itemList: [],
      publishTime: 0,
      releaseTime: 0,
      type: '',
    );
  }
}

class VideoItem {
  final String type;
  final VideoData data;
  final String tag;
  final int id;
  final int adIndex;

  VideoItem({
    required this.type,
    required this.data,
    required this.tag,
    required this.id,
    required this.adIndex,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      type: json['type'] ?? '',
      data:
          json['data'] != null
              ? VideoData.fromJson(
                json['data'] is Map<String, dynamic> ? json['data'] : {},
              )
              : VideoData.empty(),
      tag: json['tag'] ?? '',
      id: json['id'] ?? 0,
      adIndex: json['adIndex'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data.toJson(),
      'tag': tag,
      'id': id,
      'adIndex': adIndex,
    };
  }

  factory VideoItem.empty() {
    return VideoItem(
      type: '',
      data: VideoData.empty(),
      tag: '',
      id: 0,
      adIndex: -1,
    );
  }
}

class VideoData {
  final String dataType;
  final int id;
  final String title;
  final String description;
  final String library;
  final List<Tag> tags;
  final Consumption consumption;
  final String resourceType;
  final ItemProvider provider;
  final String category;
  final Author author;
  final Cover cover;
  final String playUrl;
  final int duration;
  final WebUrl webUrl;
  final int releaseTime;
  final List<PlayInfo> playInfo;
  final bool ad;
  final String type;
  final String titlePgc;
  final String descriptionPgc;
  final bool ifLimitVideo;
  final int searchWeight;
  final int idx;
  final int date;
  final String descriptionEditor;
  final bool collected;
  final bool reallyCollected;
  final bool played;
  final String? remark;
  final String? text;
  final Header? header;
  final List<VideoItem>? itemList;
  final String time;

  VideoData({
    required this.dataType,
    required this.id,
    required this.title,
    required this.description,
    required this.library,
    required this.tags,
    required this.consumption,
    required this.resourceType,
    required this.provider,
    required this.category,
    required this.author,
    required this.cover,
    required this.playUrl,
    required this.duration,
    required this.webUrl,
    required this.releaseTime,
    required this.playInfo,
    required this.ad,
    required this.type,
    required this.titlePgc,
    required this.descriptionPgc,
    required this.ifLimitVideo,
    required this.searchWeight,
    required this.idx,
    required this.date,
    required this.descriptionEditor,
    required this.collected,
    required this.reallyCollected,
    required this.played,
    this.remark,
    this.text,
    this.header,
    this.itemList,
    this.time = '',
  });

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      dataType: json['dataType'] ?? '',
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      library: json['library'] ?? '',
      tags:
          (json['tags'] as List?)
              ?.map(
                (tag) =>
                    tag != null
                        ? Tag.fromJson(tag is Map<String, dynamic> ? tag : {})
                        : Tag.empty(),
              )
              .toList() ??
          [],
      consumption:
          json['consumption'] != null
              ? Consumption.fromJson(
                json['consumption'] is Map<String, dynamic>
                    ? json['consumption']
                    : {},
              )
              : Consumption.empty(),
      resourceType: json['resourceType'] ?? '',
      provider:
          json['provider'] != null
              ? ItemProvider.fromJson(
                json['provider'] is Map<String, dynamic>
                    ? json['provider']
                    : {},
              )
              : ItemProvider.empty(),
      category: json['category'] ?? '',
      author:
          json['author'] != null
              ? Author.fromJson(
                json['author'] is Map<String, dynamic> ? json['author'] : {},
              )
              : Author.empty(),
      cover:
          json['cover'] != null
              ? Cover.fromJson(
                json['cover'] is Map<String, dynamic> ? json['cover'] : {},
              )
              : Cover.empty(),
      playUrl: json['playUrl'] ?? '',
      duration: json['duration'] ?? 0,
      webUrl:
          json['webUrl'] != null
              ? WebUrl.fromJson(
                json['webUrl'] is Map<String, dynamic> ? json['webUrl'] : {},
              )
              : WebUrl.empty(),
      releaseTime: json['releaseTime'] ?? 0,
      playInfo:
          (json['playInfo'] as List?)
              ?.map(
                (info) =>
                    info != null
                        ? PlayInfo.fromJson(
                          info is Map<String, dynamic> ? info : {},
                        )
                        : PlayInfo.empty(),
              )
              .toList() ??
          [],
      ad: json['ad'] ?? false,
      type: json['type'] ?? '',
      titlePgc: json['titlePgc'] ?? '',
      descriptionPgc: json['descriptionPgc'] ?? '',
      ifLimitVideo: json['ifLimitVideo'] ?? false,
      searchWeight: json['searchWeight'] ?? 0,
      idx: json['idx'] ?? 0,
      date: json['date'] ?? 0,
      descriptionEditor: json['descriptionEditor'] ?? '',
      collected: json['collected'] ?? false,
      reallyCollected: json['reallyCollected'] ?? false,
      played: json['played'] ?? false,
      // 新增字段解析
      remark: json['remark'],
      text: json['text'],
      header:
          json['header'] != null
              ? Header.fromJson(
                json['header'] is Map<String, dynamic> ? json['header'] : {},
              )
              : null,
      itemList:
          json['itemList'] != null
              ? (json['itemList'] as List?)
                  ?.map(
                    (item) =>
                        item != null
                            ? VideoItem.fromJson(
                              item is Map<String, dynamic> ? item : {},
                            )
                            : VideoItem.empty(),
                  )
                  .toList()
              : null,
      time: DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'dataType': dataType,
      'id': id,
      'title': title,
      'description': description,
      'library': library,
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'consumption': consumption.toJson(),
      'resourceType': resourceType,
      'provider': provider.toJson(),
      'category': category,
      'author': author.toJson(),
      'cover': cover.toJson(),
      'playUrl': playUrl,
      'duration': duration,
      'webUrl': webUrl.toJson(),
      'releaseTime': releaseTime,
      'playInfo': playInfo.map((info) => info.toJson()).toList(),
      'ad': ad,
      'type': type,
      'titlePgc': titlePgc,
      'descriptionPgc': descriptionPgc,
      'ifLimitVideo': ifLimitVideo,
      'searchWeight': searchWeight,
      'idx': idx,
      'date': date,
      'descriptionEditor': descriptionEditor,
      'collected': collected,
      'reallyCollected': reallyCollected,
      'played': played,
      'time': time,
    };

    // 添加可能为空的字段
    if (remark != null) data['remark'] = remark;
    if (text != null) data['text'] = text;
    if (header != null) data['header'] = header!.toJson();
    if (itemList != null)
      data['itemList'] = itemList!.map((item) => item.toJson()).toList();

    return data;
  }

  factory VideoData.empty() {
    return VideoData(
      dataType: '',
      id: 0,
      title: '',
      description: '',
      library: '',
      tags: [],
      consumption: Consumption.empty(),
      resourceType: '',
      provider: ItemProvider.empty(),
      category: '',
      author: Author.empty(),
      cover: Cover.empty(),
      playUrl: '',
      duration: 0,
      webUrl: WebUrl.empty(),
      releaseTime: 0,
      playInfo: [],
      ad: false,
      type: '',
      titlePgc: '',
      descriptionPgc: '',
      ifLimitVideo: false,
      searchWeight: 0,
      idx: 0,
      date: 0,
      descriptionEditor: '',
      collected: false,
      reallyCollected: false,
      played: false,
      remark: '',
      text: '',
      header: null,
      itemList: [],
      time: DateTime.now().toString(),
    );
  }
}

// Header 类 (新增)
class Header {
  final String actionUrl;
  final String description;
  final bool expert;
  final String icon;
  final String iconType;
  final int id;
  final bool ifPgc;
  final bool ifShowNotificationIcon;
  final String title;
  final int uid;

  Header({
    required this.actionUrl,
    required this.description,
    required this.expert,
    required this.icon,
    required this.iconType,
    required this.id,
    required this.ifPgc,
    required this.ifShowNotificationIcon,
    required this.title,
    required this.uid,
  });

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      actionUrl: json['actionUrl'] ?? '',
      description: json['description'] ?? '',
      expert: json['expert'] ?? false,
      icon: json['icon'] ?? '',
      iconType: json['iconType'] ?? '',
      id: json['id'] ?? 0,
      ifPgc: json['ifPgc'] ?? false,
      ifShowNotificationIcon: json['ifShowNotificationIcon'] ?? false,
      title: json['title'] ?? '',
      uid: json['uid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionUrl': actionUrl,
      'description': description,
      'expert': expert,
      'icon': icon,
      'iconType': iconType,
      'id': id,
      'ifPgc': ifPgc,
      'ifShowNotificationIcon': ifShowNotificationIcon,
      'title': title,
      'uid': uid,
    };
  }

  factory Header.empty() {
    return Header(
      actionUrl: '',
      description: '',
      expert: false,
      icon: '',
      iconType: '',
      id: 0,
      ifPgc: false,
      ifShowNotificationIcon: false,
      title: '',
      uid: 0,
    );
  }
}

class Tag {
  final int id;
  final String name;
  final String actionUrl;
  final String bgPicture;
  final String headerImage;
  final String tagRecType;
  final bool haveReward;
  final bool ifNewest;
  final int communityIndex;

  Tag({
    required this.id,
    required this.name,
    required this.actionUrl,
    required this.bgPicture,
    required this.headerImage,
    required this.tagRecType,
    required this.haveReward,
    required this.ifNewest,
    required this.communityIndex,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      actionUrl: json['actionUrl'] ?? '',
      bgPicture: json['bgPicture'] ?? '',
      headerImage: json['headerImage'] ?? '',
      tagRecType: json['tagRecType'] ?? '',
      haveReward: json['haveReward'] ?? false,
      ifNewest: json['ifNewest'] ?? false,
      communityIndex: json['communityIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'actionUrl': actionUrl,
      'bgPicture': bgPicture,
      'headerImage': headerImage,
      'tagRecType': tagRecType,
      'haveReward': haveReward,
      'ifNewest': ifNewest,
      'communityIndex': communityIndex,
    };
  }

  factory Tag.empty() {
    return Tag(
      id: 0,
      name: '',
      actionUrl: '',
      bgPicture: '',
      headerImage: '',
      tagRecType: '',
      haveReward: false,
      ifNewest: false,
      communityIndex: 0,
    );
  }
}

class Consumption {
  final int collectionCount;
  final int shareCount;
  final int replyCount;
  final int realCollectionCount;

  Consumption({
    required this.collectionCount,
    required this.shareCount,
    required this.replyCount,
    required this.realCollectionCount,
  });

  factory Consumption.fromJson(Map<String, dynamic> json) {
    return Consumption(
      collectionCount: json['collectionCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      replyCount: json['replyCount'] ?? 0,
      realCollectionCount: json['realCollectionCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionCount': collectionCount,
      'shareCount': shareCount,
      'replyCount': replyCount,
      'realCollectionCount': realCollectionCount,
    };
  }

  factory Consumption.empty() {
    return Consumption(
      collectionCount: 0,
      shareCount: 0,
      replyCount: 0,
      realCollectionCount: 0,
    );
  }
}

class ItemProvider {
  final String name;
  final String alias;
  final String icon;

  ItemProvider({required this.name, required this.alias, required this.icon});

  factory ItemProvider.fromJson(Map<String, dynamic> json) {
    return ItemProvider(
      name: json['name'] ?? '',
      alias: json['alias'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'alias': alias, 'icon': icon};
  }

  factory ItemProvider.empty() {
    return ItemProvider(name: '', alias: '', icon: '');
  }
}

class Author {
  final int id;
  final String icon;
  final String name;
  final String description;
  final String link;
  final int latestReleaseTime;
  final int videoNum;
  final Follow follow;
  final Shield shield;
  final int approvedNotReadyVideoCount;
  final bool ifPgc;
  final int recSort;
  final bool expert;

  Author({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.link,
    required this.latestReleaseTime,
    required this.videoNum,
    required this.follow,
    required this.shield,
    required this.approvedNotReadyVideoCount,
    required this.ifPgc,
    required this.recSort,
    required this.expert,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      icon: json['icon'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      latestReleaseTime: json['latestReleaseTime'] ?? 0,
      videoNum: json['videoNum'] ?? 0,
      follow:
          json['follow'] != null
              ? Follow.fromJson(
                json['follow'] is Map<String, dynamic> ? json['follow'] : {},
              )
              : Follow.empty(),
      shield:
          json['shield'] != null
              ? Shield.fromJson(
                json['shield'] is Map<String, dynamic> ? json['shield'] : {},
              )
              : Shield.empty(),
      approvedNotReadyVideoCount: json['approvedNotReadyVideoCount'] ?? 0,
      ifPgc: json['ifPgc'] ?? false,
      recSort: json['recSort'] ?? 0,
      expert: json['expert'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'description': description,
      'link': link,
      'latestReleaseTime': latestReleaseTime,
      'videoNum': videoNum,
      'follow': follow.toJson(),
      'shield': shield.toJson(),
      'approvedNotReadyVideoCount': approvedNotReadyVideoCount,
      'ifPgc': ifPgc,
      'recSort': recSort,
      'expert': expert,
    };
  }

  factory Author.empty() {
    return Author(
      id: 0,
      icon: '',
      name: '',
      description: '',
      link: '',
      latestReleaseTime: 0,
      videoNum: 0,
      follow: Follow.empty(),
      shield: Shield.empty(),
      approvedNotReadyVideoCount: 0,
      ifPgc: false,
      recSort: 0,
      expert: false,
    );
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
    return {'itemType': itemType, 'itemId': itemId, 'followed': followed};
  }

  factory Follow.empty() {
    return Follow(itemType: '', itemId: 0, followed: false);
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
    return {'itemType': itemType, 'itemId': itemId, 'shielded': shielded};
  }

  factory Shield.empty() {
    return Shield(itemType: '', itemId: 0, shielded: false);
  }
}

class Cover {
  final String feed;
  final String detail;
  final String blurred;
  final String homepage;

  Cover({
    required this.feed,
    required this.detail,
    required this.blurred,
    required this.homepage,
  });

  factory Cover.fromJson(Map<String, dynamic> json) {
    return Cover(
      feed: json['feed'] ?? '',
      detail: json['detail'] ?? '',
      blurred: json['blurred'] ?? '',
      homepage: json['homepage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feed': feed,
      'detail': detail,
      'blurred': blurred,
      'homepage': homepage,
    };
  }

  factory Cover.empty() {
    return Cover(feed: '', detail: '', blurred: '', homepage: '');
  }
}

class WebUrl {
  final String raw;
  final String forWeibo;

  WebUrl({required this.raw, required this.forWeibo});

  factory WebUrl.fromJson(Map<String, dynamic> json) {
    return WebUrl(raw: json['raw'] ?? '', forWeibo: json['forWeibo'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'raw': raw, 'forWeibo': forWeibo};
  }

  factory WebUrl.empty() {
    return WebUrl(raw: '', forWeibo: '');
  }
}

class PlayInfo {
  final int height;
  final int width;
  final List<UrlList> urlList;
  final String name;
  final String type;
  final String url;

  PlayInfo({
    required this.height,
    required this.width,
    required this.urlList,
    required this.name,
    required this.type,
    required this.url,
  });

  factory PlayInfo.fromJson(Map<String, dynamic> json) {
    return PlayInfo(
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      urlList:
          (json['urlList'] as List?)
              ?.map(
                (url) =>
                    url != null
                        ? UrlList.fromJson(
                          url is Map<String, dynamic> ? url : {},
                        )
                        : UrlList.empty(),
              )
              .toList() ??
          [],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'width': width,
      'urlList': urlList.map((url) => url.toJson()).toList(),
      'name': name,
      'type': type,
      'url': url,
    };
  }

  factory PlayInfo.empty() {
    return PlayInfo(
      height: 0,
      width: 0,
      urlList: [],
      name: '',
      type: '',
      url: '',
    );
  }
}

class UrlList {
  final String name;
  final String url;
  final int size;

  UrlList({required this.name, required this.url, required this.size});

  factory UrlList.fromJson(Map<String, dynamic> json) {
    return UrlList(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      size: json['size'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'size': size};
  }

  factory UrlList.empty() {
    return UrlList(name: '', url: '', size: 0);
  }
}
