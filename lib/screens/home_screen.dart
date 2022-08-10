import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/bloc/news_cubit.dart';
import 'package:news_app_flutter/screens/articles_screen.dart';
import 'package:news_app_flutter/utils/application_toolbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [
    'For You',
    'Top',
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];
  late NewsCubit cubit;
  int _selectedIndex = 2;

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      cubit.getNewsArticles(categories[_selectedIndex], true);
    });
  }

  _buildCategory({required int index}) {
    return GestureDetector(
      onTap: () {
        _setSelectedIndex(index);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            color: _selectedIndex == index
                ? const Color(0xff000000)
                : const Color(0xffd1cfcf)),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
            child: Text(
              categories[index],
              maxLines: 1,
              style: TextStyle(
                  color: _selectedIndex == index
                      ? const Color(0xffffffff)
                      : const Color(0xff949191)),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    cubit = context.watch<NewsCubit>();
    return Scaffold(
      appBar: const ApplicationToolbar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: SizedBox(
              height: 30.0,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCategory(index: index);
                  },
                  itemCount: 6,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                        width: 10,
                      )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 16.0, right: 16.0),
              child: ArticleScreen(category: categories[_selectedIndex]),
            ),
          )
        ],
      ),
    );
  }
}
