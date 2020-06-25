import 'package:app_recipes/model/Article_model.dart';
import 'package:app_recipes/services/webservice.dart';
import 'package:app_recipes/viewmodal/newsarticleViewModel.dart';
import 'package:flutter/cupertino.dart';

enum LoadingStatus { completed, searching, empty }

class NewsArticleViewModelList extends ChangeNotifier {
  var loadingStatus = LoadingStatus.searching;
  List<NewsarticleViewModal> articles = List<NewsarticleViewModal>();
  NewsArticleViewModelList() {
    fetchlinesNews();
  }
  void fetchlinesNews() async {
    List<Article> listNews = await Webervice().fetchTopheadlines();
    this.loadingStatus = LoadingStatus.searching;
    this.articles =
        listNews.map((article) => NewsarticleViewModal(article)).toList();
    this.loadingStatus =
        this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;

    notifyListeners();
  }

  void fetchlinesNewsbyKeywrd(String keywrd) async {
    List<Article> listNews = await Webervice().fetchByKeyword(keywrd);
    this.loadingStatus = LoadingStatus.searching;
    this.articles =
        listNews.map((article) => NewsarticleViewModal(article)).toList();
    this.loadingStatus =
        this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }
}
