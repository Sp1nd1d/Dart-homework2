import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/favorites_provider.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider); // Получаем список избранных

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body:
          favorites.isEmpty
              ? const Center(child: Text('Нет избранных статей'))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final article = favorites[index];
                  return ArticleCard(
                    article: article,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(article: article),
                          ),
                        ),
                  );
                },
              ),
    );
  }
}
