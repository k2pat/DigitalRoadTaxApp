import 'package:flutter/material.dart';

class DRTPage extends StatelessWidget {
  final String pageTitle;
  final Widget bodyWidget;
  final IconData iconData;

  DRTPage(this.pageTitle, this.bodyWidget, {this.iconData = Icons.arrow_back});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(iconData),
              onPressed: () { Navigator.pop(context); }
            );
          }
        )
      ),
      body: bodyWidget
    );
  }
}

class DRTBlankPage extends StatelessWidget {
  final Widget bodyWidget;
  final IconData iconData;

  DRTBlankPage(this.bodyWidget, {this.iconData = Icons.arrow_back});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(iconData),
              onPressed: () { Navigator.pop(context); }
            );
          }
        )
      ),
      body: bodyWidget
    );
  }
}