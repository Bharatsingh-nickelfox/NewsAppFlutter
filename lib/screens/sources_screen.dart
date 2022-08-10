import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/bloc/news_cubit.dart';
import 'package:news_app_flutter/models/source.dart';

class SourceScreen extends StatelessWidget {
  const SourceScreen({Key? key}) : super(key: key);

  createSourcesList(List<Source> sources) {
    return ListView.builder(
        itemCount: sources.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(sources[index].name ?? 'Anonymous'),
          );
        });
  }

  showEmptyState(bool apiCalledAtLeastOnce, NewsCubit cubit) {
    if (!apiCalledAtLeastOnce) {
      cubit.getNewsResources();
    }

    return const Center(
      child: Text("No Sources Found"),
    );
  }

  getLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  getErrorWidget(message) {
    return Center(child: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NewsCubit>();

    return Scaffold(
      body: cubit.state is Loading
          ? getLoadingWidget()
          : cubit.state is ErrorState
              ? getErrorWidget((cubit.state as ErrorState).errorMessage)
              : cubit.state is NoDataFound
                  ? showEmptyState(
                      (cubit.state as NoDataFound).apiCalledAtLeastOnce, cubit)
                  : cubit.state is DataFetched
                      ? createSourcesList(
                          (cubit.state as DataFetched).commonResponse.data as List<Source>)
                      : showEmptyState(false, cubit),
    );
  }
}
