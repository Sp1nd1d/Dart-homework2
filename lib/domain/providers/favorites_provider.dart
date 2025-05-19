import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/article.dart';
import 'dart:convert';

// Управление списком избранного
class FavoritesNotifier extends StateNotifier<List<Article>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites(); // Загружаем избранное из SharedPreferences
  }

  // Загрузка избранных статей
  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorites');
    if (jsonString != null) {
      final list = json.decode(jsonString) as List;
      state = list.map((e) => Article.fromJson(e)).toList();
    }
  }

  // Добавление или удаление статьи из избранного
  void toggleFavorite(Article article) async {
    final exists = state.any((a) => a.url == article.url);
    if (exists) {
      state = state.where((a) => a.url != article.url).toList(); // Удаление
    } else {
      state = [...state, article]; // Добавление
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'favorites',
      json.encode(state.map((e) => e.toJson()).toList()),
    );
  }

  bool isFavorite(Article article) => state.any((a) => a.url == article.url);
}

// Провайдер для доступа к FavoritesNotifier
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Article>>(
      (ref) => FavoritesNotifier(),
    );
