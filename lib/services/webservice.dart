import 'dart:convert';

import 'package:app_recipes/model/Article_model.dart';
import 'package:http/http.dart' as http;

class Webervice {

  Future<List<Article>> fetchTopheadlines() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=ma&apiKey=53d4943c61a14c5daf9be761020590f5";

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      Iterable list = results["articles"];
      return list.map((article) => Article.fromJSON(article)).toList();
    } else {
      throw Exception('failed to find :p');
    }
  }

  Future<List<Article>> fetchByKeyword(String keywrd) async {
    print(keywrd);
    var url ="https://newsapi.org/v2/everything?q="+keywrd+"&apiKey=53d4943c61a14c5daf9be761020590f5";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      Iterable list = results["articles"];
      return list.map((article) => Article.fromJSON(article)).toList();
    } else {
      throw Exception('failed to find :p');
    }
  }
}
