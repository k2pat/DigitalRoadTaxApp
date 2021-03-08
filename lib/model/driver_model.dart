import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:drt_app/util/snackbar.dart';

mixin DRTDriverModel on DRTBaseModel {
  List get drivers => _getDrivers();
  List get drivingVehicles => data['u_driving_vehicles'] ?? [];
  String get driverTag => data['u_driver_tag'];

  List _getDrivers() {
    List list = data['u_drivers'] ?? [];
    list.sort((a, b) {
      String aNickname = a['dr_nickname'];
      String bNickname = b['dr_nickname'];
      return aNickname.compareTo(bNickname);
    });
    return list;
  }

  bool isDriverSaved(driverTag) {
    for (Map driver in data['u_drivers'] ?? []) {
      if (driver['u_driver_tag'] == driverTag) {
        return true;
      }
    }
    return false;
  }

  bool isNicknameSaved(nickname) {
    for (Map driver in data['u_drivers'] ?? []) {
      if (driver['dr_nickname'] == nickname) {
        return true;
      }
    }
    return false;
  }

  Future<void> syncDrivingVehicles() async {
    try {
      Map params = {
        'access_token': accessToken,
      };
      Map response = await fetch('driver/sync_driving_vehicles', params);
      data['u_driving_vehicles'] = response['u_driving_vehicles'];
      await store.record('data').put(db, data);
      notifyListeners();
    }
    catch (e) {
      throw e;
    }
  }

  Map getDriversForVehicle(regNum) {
    Map ret = {};
    for (Map driver in drivers) {
      if (driver == null) continue;

      String tag = driver['u_driver_tag'];
      if (driver['dr_vehicles'].contains(regNum))
        ret[tag] = true;
      else
        ret[tag] = false;
    }
    return ret;
  }

  Future<void> updateDrivers(selectedDriverTags, regNum) async {
    Map previousSelection = getDriversForVehicle(regNum);
    List driverTagsAdd = [];
    List driverTagsRemove = [];
    for (Map driver in drivers) {
      String tag = driver['u_driver_tag'];
      if (selectedDriverTags[tag] != previousSelection[tag]) {
        if (selectedDriverTags[tag] == true)
          driverTagsAdd.add(tag);
        else
          driverTagsRemove.add(tag);
      }
    }

    Map params = {
      'access_token': accessToken,
      'driver_tags': driverTagsAdd,
      'driver_tags_remove': driverTagsRemove,
      'reg_num': regNum,
    };
    Map response = await fetch('driver/update_drivers', params);
    data['u_drivers'] = response['drivers'];
    notifyListeners();
  }

  Future<void> handleUpdateDrivers(selectedDriverTags, regNum) async {
    try {
      await updateDrivers(selectedDriverTags, regNum);
      // navigatorKey.currentState.pop();
      DRTSnackBar(message: 'Drivers saved successfully!', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
    }
    catch (e) {
      throw e;
    }
  }

  Future<void> addDriver(driverTag, nickname) async {
    try {
      if (isDriverSaved(driverTag)) throw 'This driver has already been saved';
      Map params = {
        'access_token': accessToken,
        'driver_tag': driverTag,
        'nickname': nickname,
      };
      Map response = await fetch('driver/add_driver', params);
      data['u_drivers'] = response['drivers'];
      notifyListeners();
    }
    catch (e) {
      throw e;
    }
  }

  Future<void> handleAddDriver(driverTag, nickname) async {
    try {
      await addDriver(driverTag, nickname);
      navigatorKey.currentState.pop();
      DRTSnackBar(message: 'Driver added successfully!', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
    }
    catch (e) {
      throw e;
    }
  }

  Future<void> removeDriver(driver) async {
    try {
      Map params = {
        'access_token': accessToken,
        'driver_tag': driver['u_driver_tag'],
      };
      Map response = await fetch('driver/remove_driver', params);
      data['u_drivers'] = response['drivers'];
      notifyListeners();
    }
    catch (e) {
      throw e;
    }
  }

  Future<void> handleRemoveDriver(driver) async {
    try {
      await removeDriver(driver);
      DRTSnackBar(message: 'Driver removed successfully!', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
    }
    catch (e) {
      throw e;
    }
  }
}