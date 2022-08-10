import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter/models/common_response.dart';
import 'package:news_app_flutter/screens/article_details.dart';

import '../bloc/news_cubit.dart';
import '../models/article.dart';

class ArticleScreen extends StatefulWidget {
  final String category;

  const ArticleScreen({required this.category, Key? key}) : super(key: key);

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticleScreen> {
  bool loading = false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom && !loading) {
      loading = true;
      context.read<NewsCubit>().getNewsArticles(widget.category, false);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  buildArticle(Article article) {
    return GestureDetector(
      onTap: () => article.url != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ArticleDetailsWebView(url: article.url ?? '')))
          : Fluttertoast.showToast(msg: "Oops No Details available"),
      child: SizedBox(
        height: 140.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
                width: 137.0,
                image: article.urlToImage ?? '',
                placeholder: 'assets/images/ic_placeholder_image.png',
                imageErrorBuilder: (context, error, stacktrace) => Image.asset(
                      'assets/images/ic_placeholder_image.png',
                      fit: BoxFit.cover,
                    ),
                fit: BoxFit.cover),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'By ' + (article.author ?? 'Anonymous'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        article.source.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 13.0),
                      )
                    ],
                  ))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  createArticleList(
      CommonResponse<Article> commonResponse, bool _hasReachedMax) {
    loading = false;
    final articles = commonResponse.data;
    return ListView.builder(
      itemCount: _hasReachedMax ? articles.length : articles.length + 1,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return index >= articles.length
            ? bottomLoader()
            : buildArticle(articles[index]);
      },
    );
  }

  showEmptyState(bool apiCalledAtLeastOnce, NewsCubit newsCubit) {
    loading = false;
    if (!apiCalledAtLeastOnce) {
      newsCubit.getNewsArticles(widget.category, true);
    }

    return const Center(
      child: Text("No Sources Found"),
    );
  }

  bottomLoader() {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }

  getLoadingWidget() {
    loading = false;
    return const Center(child: CircularProgressIndicator());
  }

  getErrorWidget(message) {
    loading = false;
    return Center(child: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    NewsCubit newsCubit = context.watch<NewsCubit>();

    return BlocBuilder<NewsCubit, NewsState>(builder: (context, state) {
      if (state is PaginationLoading) {
        loading = true;
      }
      return newsCubit.state is Loading
          ? getLoadingWidget()
          : newsCubit.state is ErrorState
              ? getErrorWidget((newsCubit.state as ErrorState).errorMessage)
              : newsCubit.state is NoDataFound
                  ? showEmptyState(
                      (newsCubit.state as NoDataFound).apiCalledAtLeastOnce,
                      newsCubit)
                  : newsCubit.state is DataFetched
                      ? createArticleList(
                          (newsCubit.state as DataFetched).commonResponse
                              as CommonResponse<Article>,
                          (newsCubit.state as DataFetched).hasReachedMax)
                      : showEmptyState(false, newsCubit);
    });
  }
}
