import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'ui/screens/home_screen.dart';
import 'domain/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Подготовка Flutter перед async-инициализацией
  final prefs =
      await SharedPreferences.getInstance(); // Получение локального хранилища
  final isDark = prefs.getBool('darkMode') ?? false; // Чтение состояния темы

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => ThemeNotifier(isDark)),
      ], // Внедрение состояния темы
      child: const NewsApp(), // Запуск приложения
    ),
  );
}

class NewsApp extends ConsumerWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider); // Читаем текущую тему из провайдера
    return MaterialApp(
      title: 'News App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          theme
              ? ThemeMode.dark
              : ThemeMode.light, // Устанавливаем нужный режим
      home: const HomeScreen(), // Главный экран приложения
      debugShowCheckedModeBanner: false,
    );
  }
}
