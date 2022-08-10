import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  static const _baseUrl = "https://newsapi.org/v2/";
  final _apiKey = "40ab81231e4c43fd925cdc3a0d08f7f6";
  int? _pageNo = 1;
  var resultsFetched = 0;

  Future<http.Response> fetchSources() async {
    http.Response response;
    Map<String, String> queryParams = {};
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application.json',
      HttpHeaders.authorizationHeader: _apiKey
    };

    try {
      final sourceUrl = Uri.parse(_baseUrl + 'top-headlines/sources')
          .replace(queryParameters: queryParams);

      response = await http.get(sourceUrl, headers: headers);
    } catch (e) {
      return Future.error(e);
    }
    return response;
  }

  Future<http.Response> fetchArticles(String category, bool isRefresh) async {
    http.Response response;
    if (isRefresh) {
      _pageNo = 1;
      resultsFetched = 0;
    }
    /*if (_pageNo == null) {
      return Future.error("Last Page Reached");
    }*/
    Map<String, String> queryParams = {
      'category': category,
      'pageSize': 20.toString(),
      'page': _pageNo.toString()
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application.json',
      HttpHeaders.authorizationHeader: _apiKey
    };

    try {
      final sourceUrl = Uri.parse(_baseUrl + 'top-headlines')
          .replace(queryParameters: queryParams);

      response = await http.get(sourceUrl, headers: headers);
      print("request: $sourceUrl");
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //print("ApiService: $data");
        List<dynamic> currentPageItems = data['articles'];
        resultsFetched += currentPageItems.length;
        int totalResults = data['totalResults'];
        _pageNo = resultsFetched < totalResults ? ((_pageNo ?? 0) + 1) : null;
      }
    } catch (e) {
      return Future.error(e);
    }
    return response;
  }
}
