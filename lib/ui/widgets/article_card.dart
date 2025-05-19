import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/article.dart';
import '../../domain/providers/favorites_provider.dart';

class ArticleCard extends ConsumerWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select(
        (list) => list.any((a) => a.url == article.url),
      ), // Проверка, в избранном ли
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: SizedBox(
          width: 100,
          child: FadeInImage.assetNetwork(
            placeholder:
                'assets/placeholder.jpg', // Заглушка до загрузки основного изображения
            image: article.urlToImage, // Загружаемое основное изображение
            fit: BoxFit.cover,
            imageErrorBuilder:
                (context, error, stackTrace) => Image.asset(
                  'assets/placeholder.jpg', // Если загрузка неудачна - показывается заглушка
                  fit: BoxFit.cover,
                ),
          ),
        ),
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          article.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : null,
          ),
          onPressed:
              () =>
                  ref.read(favoritesProvider.notifier).toggleFavorite(article),
        ),
        onTap: onTap,
      ),
    );
  }
}
