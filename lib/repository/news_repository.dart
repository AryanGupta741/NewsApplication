import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/categories_new_model.dart';
import 'package:newsapp/models/news_channel_headlines_modle.dart';

/*
creating an API repository is a common software design pattern used to separate concerns and manage the interaction with external APIs. API repositories serve several important purposes: 
*/

class NewsRepository {
  // future function and async is used because we don't know how much time taken by the internet or server or api to fetech the data

  Future<NewsChannelsHeadlinesModel>
      // why are using function name is same in another dart file ,
      // because the multiple function is created then is difficult to remember which data retrieve in which function. so, with help of these can easily understand and remember.

      fetchNewChannelHeadlinesApi(String name) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${name}&apiKey=e7de6298204d4af180c140825d35347b';

// the await function is used because to await the few minutes for fetch the some data.

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
// it return the postman body as response to the function.

      // first of all convert the json file in body formate

      /* =========== If the API returns JSON data, you'll need to parse it into Dart objects. You can use the dart:convert library for this purpose: ===========*/

      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }

// ========================================
// news repository of categoriesNewsapi
//==========================================

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=e7de6298204d4af180c140825d35347b';

    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception('error');
    }
  }
}
