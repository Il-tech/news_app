class Article {
  final String title;
  final String description, imgURL, url;
  //initialize inside constructor
  Article({this.title, this.description, this.imgURL, this.url});
  factory Article.fromJSON(Map<String, dynamic> json) {
    return Article(
        title: json["title"],
        description: json["description"],
        imgURL: json["urlToImage"],
        url: json["url"]);
  }
}
