import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final _prefs = SharedPreferences.getInstance();

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() async {
    final prefs = await _prefs;
    final savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  void setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await _prefs;
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
}
