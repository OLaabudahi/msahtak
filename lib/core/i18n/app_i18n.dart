import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/language/bloc/language_bloc.dart';
import '../../services/language_service.dart';

extension AppI18n on BuildContext {
  String t(String key) {
    try {
      final languageBloc = read<LanguageBloc>();
      final code = languageBloc.state.code;
      return LanguageService.tr(code, key);
    } catch (_) {
      final code = LanguageService.supported.first.code;
      return LanguageService.tr(code, key);
    }
  }

  bool get isArabic {
    try {
      final languageBloc = read<LanguageBloc>();
      return languageBloc.state.code == 'ar';
    } catch (_) {
      return LanguageService.supported.first.code == 'ar';
    }
  }
}
