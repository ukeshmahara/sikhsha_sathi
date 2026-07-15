import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/app/locale/locale_state.dart';

const String _kLanguageKey = 'app_language';

final localeViewModelProvider =
    NotifierProvider<LocaleViewModel, LocaleState>(LocaleViewModel.new);

class LocaleViewModel extends Notifier<LocaleState> {
  late final SharedPreferences _prefs;

  @override
  LocaleState build() {
    _prefs = ref.read(sharedPreferencesProvider);

    final saved = _prefs.getString(_kLanguageKey);
    final language = AppLanguage.values.firstWhere(
      (l) => l.name == saved,
      orElse: () => AppLanguage.english,
    );

    return LocaleState(language: language);
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setString(_kLanguageKey, language.name);
    state = state.copyWith(language: language);
  }

  Future<void> toggleLanguage() async {
    final next = state.language == AppLanguage.english
        ? AppLanguage.nepali
        : AppLanguage.english;
    await setLanguage(next);
  }
}