import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

const URI = 'http://192.168.0.101:8001/app';
const HOST = '192.168.0.101';
const PORT = 8001;

Future<Map> fetch(route, params) async {
    Response response = await post(
      URI + '/' + route,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(params),
    );
    Map body = jsonDecode(response.body);
    if (response.statusCode != 200) throw body['errorMsg'];
    return body;
  // try {
  //   route = 'app/' + route;
  //   HttpClientRequest request = await HttpClient().post(HOST, PORT, route)
  //     ..headers.contentType = ContentType.json
  //     ..write(jsonEncode(params));
  //   HttpClientResponse response = await request.close().timeout(const Duration(seconds: 5));
  //   Map body = jsonDecode(response.body);
  //   // if (response.statusCode != 200) throw body['errorMsg'];
  //   // return body;
  //
  // } on TimeoutException catch(e) {
  //   print(e);
  //   throw e;
  // }
}