import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';
import 'package:flutter_eyepetizer/module/daily/daily_view_model.dart';
import 'package:lib_utils/lib_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DailyPageWrapper extends StatelessWidget {
  const DailyPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailyViewModel(),
      child: const DailyPage('日报'),
    );
  }
}

class DailyPage extends StatefulWidget {
  const DailyPage(this.title, {super.key});

  final String title;

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage>
    with BasePage<DailyPage>, AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late DailyViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<DailyViewModel>(context, listen: false);
      _viewModel.refreshDailyData();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await _viewModel.refreshDailyData();
    if (_viewModel.hasError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
    if (_viewModel.hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  void _onLoadMore() async {
    await _viewModel.loadMoreData();
    if (_viewModel.hasError) {
      _refreshController.loadFailed();
    } else {
      if (_viewModel.hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(
        context,
        widget.title,
        showBack: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showTip('开发中');
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),
      body: Consumer<DailyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.items.isEmpty) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.hasError) {
              return RetryWidget(onTapRetry: _onRefresh);
            }
            return const EmptyWidget();
          }

          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: ClassicHeader(),
            footer: ClassicFooter(),
            onRefresh: _onRefresh,
            onLoading: _onLoadMore,
            child: ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];

                if (item.type == 'textFooter') {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      item.data.text ?? "",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (item.type == 'textHeader') {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      item.data.text ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (item.type == 'videoCollectionWithCover') {
                  // 嵌套集合数据处理
                  final nestedItems = item.data.itemList ?? [];
                  if (nestedItems.isEmpty) return SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题部分
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          item.data.header?.title ?? "视频集合",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // 水平滚动列表
                      SizedBox(
                        height: 180, // 固定高度
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: nestedItems.length,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, nestedIndex) {
                            final nestedItem = nestedItems[nestedIndex];
                            return Container(
                              width: 160, // 固定宽度
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 视频封面
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      nestedItem.data.cover.feed,
                                      height: 120,
                                      width: 160,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (ctx, err, _) => Container(
                                            height: 120,
                                            width: 160,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.error),
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  // 视频标题
                                  Text(
                                    nestedItem.data.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (item.type == 'videoCollectionOfFollow') {
                  // 嵌套集合数据处理
                  final nestedItems = item.data.itemList ?? [];
                  if (nestedItems.isEmpty) return SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题部分
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          item.data.header?.title ?? "视频集合",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // 水平滚动列表
                      SizedBox(
                        height: 180, // 固定高度
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: nestedItems.length,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, nestedIndex) {
                            final nestedItem = nestedItems[nestedIndex];
                            return Container(
                              width: 160, // 固定宽度
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 视频封面
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      nestedItem.data.cover.feed,
                                      height: 120,
                                      width: 160,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (ctx, err, _) => Container(
                                            height: 120,
                                            width: 160,
                                            color: Colors.grey[200],
                                            child: Icon(Icons.error),
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  // 视频标题
                                  Text(
                                    nestedItem.data.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(item.data.title),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
