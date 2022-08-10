import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetailsWebView extends StatefulWidget {
  final String url;

  const ArticleDetailsWebView({required this.url, Key? key}) : super(key: key);

  @override
  State<ArticleDetailsWebView> createState() => _ArticleDetailsWebViewState();
}

class _ArticleDetailsWebViewState extends State<ArticleDetailsWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
