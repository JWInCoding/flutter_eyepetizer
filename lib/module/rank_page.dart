import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with BasePage<RankPage>, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(context, '热门', showBack: false),
      body: Center(child: Text('热门')),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
