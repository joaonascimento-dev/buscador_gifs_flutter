import 'package:http/http.dart' as http;
//import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Repository {
  //api.giphy.com/v1/gifs/search?
  //api_key=X
  //q=busca
  //limit=20
  //rating=g

  Future<Map> buscarGifs(String busca) async {
    await dotenv.load(fileName: "keys.env");
    var key = dotenv.env['API_KEY'];
    final Uri uri = Uri.https("api.giphy.com", "/v1/gifs/search",
        {"api_key": key, "q": busca, "limit": "20", "rating": "g"});
    final resultado = await http.get(uri);
    return json.decode(resultado.body);
  }

  Future<Map> buscarTranding() async {
    await dotenv.load(fileName: "keys.env");
    var key = dotenv.env['API_KEY'];
    final Uri uri = Uri.https("api.giphy.com", "/v1/gifs/trending",
        {"api_key": key, "limit": "20", "rating": "g"});
    final resultado = await http.get(uri);
    return json.decode(resultado.body);
  }

  /*Future<String> loadKey() async {
    return await rootBundle.loadString('../../../api_giphy.txt');
  }*/
}
