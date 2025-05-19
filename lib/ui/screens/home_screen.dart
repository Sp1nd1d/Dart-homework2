import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/article.dart';
import '../../domain/providers/api_provider.dart';
import '../../domain/providers/theme_provider.dart';
import '../widgets/article_card.dart';
import 'favorites_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController =
      ScrollController(); // Контроллер прокрутки
  final List<Article> _articles = []; // Список новостей

  int _currentPage = 1; // Текущая страница пагинации
  bool _isLoading = false; // Флаг загрузки
  bool _hasMore = true; // Флаг наличия следующих страниц

  @override
  void initState() {
    super.initState();
    _fetchArticles(); // Загрузка первой партии статей
    _scrollController.addListener(
      _onScroll,
    ); // Подключаем скролл (слежка за прокруткой списка)
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Освобождаем контроллер
    super.dispose();
  }

  // Обработка скролла: если близко к концу и можно загрузить — загружаем
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoading &&
        _hasMore) {
      _fetchArticles();
    }
  }

  // Загрузка новостей через ApiService
  void _fetchArticles() async {
    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiProvider); // получаем сервис API из провайдера
      final newArticles = await api.fetchArticles(page: _currentPage);
      if (newArticles.isEmpty) {
        _hasMore = false; // Больше страниц нет
      } else {
        _articles.addAll(newArticles); // Добавляем в список
        _currentPage++; // Переходим на следующую страницу
      }
    } catch (e) {
      debugPrint('Ошибка загрузки: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider); // Получаем текущую тему

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                ),
          ),
          IconButton(
            icon: Icon(theme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
          ),
        ],
      ),
      body:
          _articles.isEmpty && _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Индикатор при первой загрузке
              : ListView.builder(
                controller: _scrollController,
                itemCount:
                    _articles.length +
                    (_hasMore ? 1 : 0), // +1 если есть ещё страница
                itemBuilder: (context, index) {
                  if (index == _articles.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ), // Индикатор внизу
                    );
                  }
                  final article = _articles[index];
                  return ArticleCard(
                    article: article,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailScreen(
                                  article: article,
                                ), // Переход к подробностям
                          ),
                        ),
                  );
                },
              ),
    );
  }
}
