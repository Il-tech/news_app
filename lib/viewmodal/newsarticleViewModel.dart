import 'package:app_recipes/model/Article_model.dart';

class NewsarticleViewModal {
  Article article;
  NewsarticleViewModal(Article art) : this.article = art;

  String get title {
    return article.title;
  }

  String get description {
    return article.description;
  }

  String get imgUrl {
    return article.imgURL;
  }
  String get url {
    return article.url;
  }
}
