import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework1/data/models/article.dart';
import 'package:homework1/ui/widgets/article_card.dart';

void main() {
  testWidgets('ArticleCard displays data', (WidgetTester tester) async {
    final article = Article(
      title: 'Sample Title',
      description: 'Sample Description',
      content: 'Sample Content',
      url: 'https://example.com',
      urlToImage: '',
    ); // Создаём тестовую статью

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: ArticleCard(article: article, onTap: () {})),
      ),
    ); // Рендеринг ArticleCard внутри MaterialApp и ProviderScope

    expect(
      find.text('Sample Title'),
      findsOneWidget,
    ); // Проверяет появление заголовка статьи
    expect(
      find.text('Sample Description'),
      findsOneWidget,
    ); // Проверяет появление описания статьи
    expect(
      find.byIcon(Icons.favorite_border),
      findsOneWidget,
    ); // Проверяет появление иконки избранного
    expect(find.byType(FadeInImage), findsOneWidget); // Проверка изображения
    expect(find.byType(Image), findsWidgets); // Проверка отображения картинки
  });
}
