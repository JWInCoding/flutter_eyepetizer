import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';
import 'package:lib_utils/lib_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.title, {super.key});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
            tooltip: '搜索',
          ),
        ],
      ),
      body: Center(child: Text(widget.title)),
    );
  }
}
