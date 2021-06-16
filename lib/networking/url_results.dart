import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'fetching_urls.dart';

Future<RequestModel> fetchurl(String FCMTocken) async {
  final response = await http.post('https://q8aqar.com/inc/app.php', body: {
    "apptoken": FCMTocken,
    "appdevice": Platform.operatingSystem.toLowerCase(),
  });

  if (response.statusCode == 200) {
    print('url result');
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return RequestModel.fromJson(jsonDecode(response.body));
  } else {
    print(' invalide url');

    throw Exception('Failed to load album');
  }
}
