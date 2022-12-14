import 'package:news_app_flutter/models/source.dart';

class Article {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  Article(this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content);

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
        Source.fromMap(map['source']),
        map['author'],
        map['title'],
        map['description'],
        map['url'],
        map['urlToImage'],
        map['publishedAt'],
        map['content']);
  }
}
