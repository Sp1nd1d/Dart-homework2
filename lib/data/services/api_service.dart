import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  final String _apiKey = '0f2038137ec9480bb06cbc5b468e11b9'; // API ключ
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines'; // URL запоса

  // Метод загрузки списка статей с пагинацией
  Future<List<Article>> fetchArticles({int page = 1, int pageSize = 20}) async {
    final uri = Uri.parse(
      '$_baseUrl?country=us&pageSize=$pageSize&page=$page&apiKey=$_apiKey',
    );

    final response = await http.get(uri); // GET-запрос к API

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return (data['articles'] as List)
            .map((json) => Article.fromJson(json))
            .toList(); // Преобразование JSON в список Article
      } else {
        throw Exception('API error: ${data['message']}');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }
}
