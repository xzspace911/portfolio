import 'package:flutter/material.dart';

/// Holds the active [ThemeMode] and flips it. Dark is the signature default;
/// light is a first-class alternative. Deliberately tiny — a static site
/// doesn't need heavier state management (readability over cleverness).
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void set(ThemeMode mode) {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
  }
}
