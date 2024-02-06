// news repository calling in the news view model

import 'package:newsapp/models/categories_new_model.dart';
import 'package:newsapp/models/news_channel_headlines_modle.dart';
import 'package:newsapp/repository/news_repository.dart';

class NewsViewModel {
  //  _(underscore) to indicate that they are private within the current library, file,  function. variable e.t.c.
  // rep store the body of the api and also called api calling
  final _rep = NewsRepository();

  /* why are using function name is same in another dart file ,
  because the multiple function is created then is difficult to remember which data retrieve in which function. so, with help of these can easily understand and remember.*/

  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(
      String name) async {
// and then fetch the headlines in the newsapi

    final response = await _rep.fetchNewChannelHeadlinesApi(name);
    return response;
  }

// ========================================
// news Model of categoriesNewsapi
//============================================

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}
