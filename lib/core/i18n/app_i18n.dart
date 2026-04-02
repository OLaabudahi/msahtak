import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/language/bloc/language_bloc.dart';
import '../../services/language_service.dart';

extension AppI18n on BuildContext {
  String t(String key) {
    final code = select((LanguageBloc b) => b.state.code);
    return LanguageService.tr(code, key);
  }

  bool get isArabic {
    final code = select((LanguageBloc b) => b.state.code);
    return code == 'ar';
  }
}


