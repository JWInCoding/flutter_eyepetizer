class CategoryModel {
  final int id;
  final String name;
  final String? alias;
  final String description;
  final String bgPicture;
  final String bgColor;
  final String headerImage;
  final int defaultAuthorId;
  final int tagId;

  CategoryModel({
    required this.id,
    required this.name,
    this.alias,
    required this.description,
    required this.bgPicture,
    required this.bgColor,
    required this.headerImage,
    required this.defaultAuthorId,
    required this.tagId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      alias: json['alias'],
      description: json['description'],
      bgPicture: json['bgPicture'],
      bgColor: json['bgColor'],
      headerImage: json['headerImage'],
      defaultAuthorId: json['defaultAuthorId'],
      tagId: json['tagId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'description': description,
      'bgPicture': bgPicture,
      'bgColor': bgColor,
      'headerImage': headerImage,
      'defaultAuthorId': defaultAuthorId,
      'tagId': tagId,
    };
  }

  // 添加处理列表的静态方法
  static List<CategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
