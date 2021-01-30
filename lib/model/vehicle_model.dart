import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:sembast/sembast.dart';

mixin DRTVehicleModel on DRTBaseModel {
  List get vehicles => data['u_vehicles'];

  // Future<List> get vehicles async {
  //   List vehicles = (await store.record('data').get(db))['u_vehicles'];
  //   return vehicles;
  // }

  Future syncVehicles() async {
    try {
      Map params = {
        'access_token': accessToken,
      };
      Map response = await fetch('sync_vehicles', params);
      data['u_vehicles'] = response['u_vehicles'];
      await store.record('data').put(db, data);
      notifyListeners();
    }
    catch (e) {
      throw e;
    }
  }
}