import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/models/article.dart';
import 'package:news_app_flutter/models/common_response.dart';
import 'package:news_app_flutter/models/source.dart';
import 'package:news_app_flutter/repository/news_repository.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;

  NewsCubit(this._repository) : super(NoDataFound(false));

  Future getNewsResources() async {
    emit(Loading());

    try {
      final sources = await _repository.getNewsSources();

      if (sources.isEmpty) {
        emit(NoDataFound(true));
      } else {
        emit(DataFetched<Source>(CommonResponse("ok", 0, sources), false));
      }
    } on Exception catch (e) {
      print("cubit:error" + e.toString());
      emit(ErrorState(e.toString()));
    }
  }

  Future getNewsArticles(String category, bool isRefresh) async {
    if(isRefresh) {
      emit(Loading());
    }

    try {
      final commonResponse =
          await _repository.getNewsArticles(category, isRefresh);

      if (isRefresh) {
        if (commonResponse.data.isEmpty) {
          emit(NoDataFound(true));
        } else {
          emit(DataFetched<Article>(commonResponse, false));
        }
      } else {
        final maxReached = commonResponse.data.isEmpty;
        final articles = state is DataFetched
            ? (state as DataFetched<Article>).commonResponse.data
            : List.empty();
        articles.addAll(commonResponse.data);
        commonResponse.data = articles as List<Article>;
        emit(DataFetched<Article>(commonResponse, maxReached));
      }
    } on Exception catch (e) {
      print("cubit:error" + e.toString());
      emit(ErrorState(e.toString()));
    }
  }
}

abstract class NewsState {}

class NoDataFound extends NewsState {
  bool apiCalledAtLeastOnce;

  NoDataFound(this.apiCalledAtLeastOnce);
}

class ErrorState extends NewsState {
  final String? errorMessage;

  ErrorState(this.errorMessage);
}

class Loading extends NewsState {}

class PaginationLoading extends NewsState {}

class DataFetched<T> extends NewsState {
  final CommonResponse<T> commonResponse;
  final bool hasReachedMax;

  DataFetched(this.commonResponse, this.hasReachedMax);
}
