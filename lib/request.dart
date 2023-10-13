import 'package:dio/dio.dart';

import 'newsDataModel.dart';

Future<List<News>> getNews() async {
  final dio = Dio();
  final response = await dio.get('https://webstripe.ru/list.json');

  if (response.statusCode == 200) {
    final data = response.data;

    if (data is Map && data.containsKey('news')) {
      final newsList = data['news'];
      if (newsList is List) {
        return newsList.map<News>((json) => News.fromJson(json)).toList();
      }
    }
  }
  return <News>[];
}
