import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final storage = GetStorage();

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadThemePref();
  }

  Future<void> _loadThemePref() async {
    final themeIndex = storage.read('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await storage.write('themeMode', mode.index);
    notifyListeners();
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF1A2341), // Bleu foncé pour titres et accents
    secondary: Color(0xFFFFD84D), // Bouton secondaire (Se connecter)
    background: Color(0xFFFFFFFF), // Fond clair
    onBackground: Color(0xFF1A2341), // Texte principal sur fond clair
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFFFD84D), // Jaune africoin pour éléments importants
    secondary: Color(0xFFC5C9D8), // Gris clair pour textes secondaires
    background: Color(0xFF1A2341), // Bleu foncé en fond
    onBackground: Color(0xFFFFFFFF), // Texte blanc sur fond sombre
  ),
);
