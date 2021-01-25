import 'package:drt_app/view/drawer.dart';
import 'package:drt_app/view/driving_list_page.dart';
import 'package:drt_app/view/vehicles_list_page.dart';
import 'package:flutter/material.dart';

class DRTHomePage extends StatefulWidget {
  static const routeName = '/home';

  DRTHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DRTHomePageState createState() => _DRTHomePageState();
}

class _DRTHomePageState extends State<DRTHomePage> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('YOUR VEHICLES')),
              Tab(child: Text('DRIVING VEHICLES')),
            ], indicatorColor: Colors.white,
            controller: tabController,
          )
      ),
      drawer: DRTDrawer(),
      body: TabBarView(
        controller: tabController,
        children: [
          DRTVehiclesListPage(),
          DRTDrivingListPage(),
        ],
      ),
    );
  }
}