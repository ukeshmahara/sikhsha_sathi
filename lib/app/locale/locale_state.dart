import 'package:equatable/equatable.dart';

enum AppLanguage { english, nepali }

class LocaleState extends Equatable {
  final AppLanguage language;

  const LocaleState({
    this.language = AppLanguage.english,
  });

  LocaleState copyWith({AppLanguage? language}) {
    return LocaleState(language: language ?? this.language);
  }

  @override
  List<Object?> get props => [language];
}