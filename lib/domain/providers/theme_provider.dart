import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Управление состоянием темы
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(super.isDark);

  bool get isDark => state;

  // Переключение темы
  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', state); // Сохраняем текущую тему
  }
}

// Провайдер для доступа к ThemeNotifier
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>(
  (ref) => ThemeNotifier(false),
);
