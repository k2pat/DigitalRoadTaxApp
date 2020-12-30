import 'dart:convert';

import 'package:http/http.dart';

const URI = 'http://192.168.0.101/api';

Future<Map> fetch(route, params) async {
  Response response = await post(
    URI + '/' + route,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(params),
  );
  return jsonDecode(response.body);
}