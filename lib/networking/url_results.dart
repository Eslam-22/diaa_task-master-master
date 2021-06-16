import 'dart:convert';
import 'package:http/http.dart' as http;
import 'fetching_urls.dart';

Future<Statuse> fetchurl(appurl) async {
  final response = await http.get('https://q8aqar.com/inc/app.php');

  if (response.statusCode == 200) {
    print('url result');
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Statuse.fromJson(jsonDecode(response.body));
  } else {
    print(' invalide url');

    throw Exception('Failed to load album');
  }
}


