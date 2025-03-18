import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';

class RankPage extends StatefulWidget {
  const RankPage(this.title, {super.key});

  final String title;

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.title, showBack: false),
      body: Center(child: Text(widget.title)),
    );
  }
}
