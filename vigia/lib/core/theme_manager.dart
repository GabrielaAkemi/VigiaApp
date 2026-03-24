import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  // Começamos no modo escuro (Noturno) por padrão
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  // Função que o botão do perfil vai chamar
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    // Isso avisa todos os widgets para redesenharem com as novas cores
    notifyListeners();
  }
}