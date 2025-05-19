import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homework1/data/models/article.dart';
import 'package:homework1/domain/providers/favorites_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Инициализирует окружение для тестов

  test('Toggle favorite article', () async {
    SharedPreferences.setMockInitialValues(
      {},
    ); // Очистка хранилища перед тестом

    final container =
        ProviderContainer(); // Создание пустого контейнера Riverpod
    final article = Article(
      title: 'Test',
      description: 'Desc',
      content: 'Content',
      url: 'https://test.com',
      urlToImage: 'https://test.com/image.jpg',
    ); // Создаём тестовую статью

    final notifier = container.read(
      favoritesProvider.notifier,
    ); // Получение доступа к методам управления (add, remove и т.д.)
    expect(
      container.read(favoritesProvider).contains(article),
      false,
    ); // Проверяем, что статья не в избранном

    notifier.toggleFavorite(article); // Добавляем статью в избранное
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      container.read(favoritesProvider).any((a) => a.url == article.url),
      true,
    ); // Проверяем, что статья теперь в избранном

    notifier.toggleFavorite(article); // Удаляем из избранного
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      container.read(favoritesProvider).any((a) => a.url == article.url),
      false,
    ); // Проверяем, что статья больше не в избранном
  });
}
