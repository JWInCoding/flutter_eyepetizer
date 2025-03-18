import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:flutter_eyepetizer/base/base_page.dart';

class MinePage extends StatefulWidget {
  const MinePage(this.title, {super.key});

  final String title;

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with BasePage<MinePage>, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(context, widget.title, showBack: false),
      body: Center(child: Text(widget.title)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
