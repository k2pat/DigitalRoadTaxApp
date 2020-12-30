import 'package:flutter/material.dart';

class DRTPage extends StatelessWidget {
  final String pageTitle;
  final Widget bodyWidget;

  DRTPage(this.pageTitle, this.bodyWidget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: bodyWidget
    );
  }
}

class DRTBlankPage extends StatelessWidget {
  final Widget bodyWidget;

  DRTBlankPage(this.bodyWidget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: bodyWidget
    );
  }
}