import 'dart:convert';
import 'dart:io';

import 'package:news_app_flutter/models/article.dart';
import 'package:news_app_flutter/models/common_response.dart';
import 'package:news_app_flutter/models/source.dart';
import 'package:news_app_flutter/services/api_services.dart';

class NewsRepository {
  Future<List<Source>> getNewsSources() async {
    try {
      final response = await APIService.instance.fetchSources();
      //print("response:"+response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> sourcesJson = data['sources'];
        List<Source> sources = [];

        for (var json in sourcesJson) {
          sources.add(Source.fromMap(json));
        }
        return sources;
      } else {
        throw Exception(json.decode(response.body)['error']['message']);
      }
    } on SocketException catch (e) {
      rethrow;
    } on HttpException catch (e) {
      rethrow;
    } on FormatException catch (e) {
      rethrow;
    }
  }

  Future<CommonResponse<Article>> getNewsArticles(
      String category, bool isRefresh) async {
    try {
      final response =
          await APIService.instance.fetchArticles(category, isRefresh);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> currentPageArticles = data['articles'];
        List<Article> articles = [];

        for (var json in currentPageArticles) {
          articles.add(Article.fromMap(json));
        }

        return CommonResponse(data['status'], data['totalResults'], articles);
      } else {
        throw Exception(json.decode(response.body)['error']['message']);
      }
    } on SocketException catch (e) {
      rethrow;
    } on HttpException catch (e) {
      rethrow;
    } on FormatException catch (e) {
      rethrow;
    }
  }
}
