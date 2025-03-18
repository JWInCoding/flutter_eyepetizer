import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/base/appbar_widget.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage(this.title, {super.key});

  final String title;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.title, showBack: false),
      body: Center(child: Text(widget.title)),
    );
  }
}
