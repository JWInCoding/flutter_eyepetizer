import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/common/utils/cache_image.dart';
import 'package:flutter_eyepetizer/common/utils/navigator_util.dart';
import 'package:flutter_eyepetizer/common/utils/request_util.dart';
import 'package:flutter_eyepetizer/common/utils/toast_utils.dart';
import 'package:flutter_eyepetizer/common/widget/adaptive_progress_indicator.dart';
import 'package:flutter_eyepetizer/config/Api.dart';
import 'package:flutter_eyepetizer/module/category/category_detail_page.dart';
import 'package:flutter_eyepetizer/module/category/category_model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with BasePage<CategoryPage>, AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _hasError = false;
  List<CategoryModel> _categoryList = [];
  // 用于存储每个分类ID对应的颜色
  final Map<int, Color> _categoryColors = {};

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _loadCategoryList();
  }

  void _loadCategoryList() async {
    try {
      List<CategoryModel>? response = await HttpGo.instance.get(
        API.categoryList,
        fromJson: (json) => CategoryModel.fromJsonList(json as List),
      );

      // 为每个分类预先分配一个颜色
      final Map<int, Color> colors = {};
      if (response != null) {
        for (var category in response) {
          colors[category.id] = _getRandomColor();
        }
      }

      setState(() {
        _categoryList = response!;
        _categoryColors.addAll(colors);
        _isLoading = false;
        // 在数据加载完成后初始化TabController
      });
    } catch (e) {
      showTip(e.toString());
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // 预定义一个鲜明的颜色列表
  final List<Color> _distinctColors = [
    Color(0xFFE91E63), // 粉红
    Color(0xFF9C27B0), // 紫色
    Color(0xFF673AB7), // 深紫色
    Color(0xFF3F51B5), // 靛蓝
    Color(0xFF2196F3), // 蓝色
    Color(0xFF03A9F4), // 浅蓝
    Color(0xFF00BCD4), // 青色
    Color(0xFF009688), // 茶绿
    Color(0xFF4CAF50), // 绿色
    Color(0xFF8BC34A), // 浅绿
    Color(0xFFCDDC39), // 酸橙
    Color(0xFFFFEB3B), // 黄色
    Color(0xFFFFC107), // 琥珀
    Color(0xFFFF9800), // 橙色
    Color(0xFFFF5722), // 深橙
    Color(0xFFF44336), // 红色
    Color(0xFF795548), // 棕色
    Color(0xFF607D8B), // 蓝灰
  ];

  // 随机但保证差异明显的颜色生成
  Color _getRandomColor() {
    // 使用几种策略之一（可以根据需要调整）
    int strategy = _random.nextInt(3);

    switch (strategy) {
      case 0:
        // 从预定义颜色中选择
        return _distinctColors[_random.nextInt(_distinctColors.length)];

      case 1:
        // 使用饱和度和亮度较高的HSV生成
        double hue = _random.nextInt(360).toDouble();
        double saturation = 0.7 + _random.nextDouble() * 0.3; // 0.7-1.0
        double brightness = 0.6 + _random.nextDouble() * 0.3; // 0.6-0.9
        return HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();

      case 2:
      default:
        // 使用Material Design调色板
        List<MaterialAccentColor> accents = Colors.accents;
        MaterialAccentColor color = accents[_random.nextInt(accents.length)];
        return color[_random.nextBool() ? 400 : 700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return const Scaffold(body: Center(child: AdaptiveProgressIndicator()));
    }
    if (_hasError) {
      return RetryWidget(onTapRetry: _loadCategoryList);
    }
    if (_categoryList.isEmpty) {
      return const EmptyWidget();
    }

    // 计算屏幕宽度及相关尺寸
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = 16.0; // 内边距
    final double spacing = 20.0; // 项目间距
    final double itemWidth = (screenWidth - (padding * 2) - spacing) / 2;
    final double itemHeight = itemWidth * 0.7;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            // 配置更好的滚动效果
            SliverAppBar(
              toolbarHeight: 0,
              floating: true,
              pinned: false,
              snap: true, // 启用snap可以获得更好的滚动效果
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(_categoryList.length, (index) {
                final category = _categoryList[index];

                return GestureDetector(
                  onTap: () {
                    toPage(
                      () => CategoryDetailPage(
                        category: category,
                        appbarBackgroundColor: _categoryColors[category.id],
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 半透明遮罩
                        Container(
                          width: itemWidth,
                          height: itemHeight,
                          color:
                              _categoryColors[category.id] ?? _getRandomColor(),
                        ),
                        // 图片
                        CacheImage.network(
                          url: category.bgPicture,
                          width: itemWidth,
                          height: itemHeight,
                          fit: BoxFit.cover,
                        ),
                        // 文本
                        Text(
                          category.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
