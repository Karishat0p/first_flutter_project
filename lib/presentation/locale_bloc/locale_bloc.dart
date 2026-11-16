import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_flutter_project/components/locale/l10n/app_locale.dart'; // <--- Импорт твоего AppLocale
import 'locale_events.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  //в конструкторе принимаем язык по умолчанию
  LocaleBloc(Locale defaultLocale) : super(LocaleState(currentLocale: defaultLocale)) {
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onChangeLocale(ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    //ищем поддерживаемый язык
    final toChange = AppLocale.supportedLocales
        .firstWhere((e) => e.languageCode != state.currentLocale.languageCode);

    //обновляем стейт
    emit(state.copyWith(currentLocale: toChange));
  }
}