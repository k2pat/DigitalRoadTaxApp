import 'package:drt_app/model/account_model.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DRTBaseModel extends Model {
  final SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
  final Database db = GetIt.I<Database>();
  final store = StoreRef.main();
  final GlobalKey<NavigatorState> navigatorKey = GetIt.I<GlobalKey<NavigatorState>>();

  //DRTModel(this.sharedPreferences, this.db);
}

class DRTModel extends DRTBaseModel
    with DRTAccountModel {}