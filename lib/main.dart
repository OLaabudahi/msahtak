import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masahtak_app/features/app_start/data/repos/app_start_repo_dummy.dart';
import 'package:masahtak_app/features/auth/data/sources/auth_dummy_source.dart';

import 'app/app_root.dart';
import 'theme/app_colors.dart';
import 'features/app_start/bloc/app_start_event.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/auth/data/repos/auth_repo_dummy.dart';
import 'features/app_start/bloc/app_start_bloc.dart';
import 'features/language/bloc/language_event.dart';
import 'features/language/bloc/language_state.dart';
import 'services/language_service.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();
  // إذا عندك init/ready لازم تناديها هون:
  // await storage.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepoDummy(AuthDummySource(storage))),
        ),
        BlocProvider(
          create: (_) => AppStartBloc(AppStartRepoDummy(storage))
            ..add(const AppStartStarted()),
        ),
        BlocProvider(
          create: (_) => LanguageBloc(LanguageService(storage))
            ..add(const LanguageStarted()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(langState.code),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.btnPrimary,
                foregroundColor: AppColors.btnPrimaryText,
                minimumSize: const Size(double.infinity, 52),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnPrimary,
                foregroundColor: AppColors.btnPrimaryText,
                minimumSize: const Size(double.infinity, 52),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: AppRoot.withBloc(),
        );
      },
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masahtak_app/features/app_start/data/repos/app_start_repo_dummy.dart';
import 'package:masahtak_app/features/auth/data/sources/auth_dummy_source.dart';

import 'app/app_root.dart';
import 'theme/app_colors.dart';
import 'features/app_start/bloc/app_start_event.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/auth/data/repos/auth_repo_dummy.dart';
import 'features/app_start/bloc/app_start_bloc.dart';
import 'features/language/bloc/language_event.dart';
import 'features/language/bloc/language_state.dart';
import 'services/language_service.dart';
import 'services/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();

  MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthBloc(AuthRepoDummy(AuthDummySource(storage))),
      ),

      BlocProvider(
        create: (_) =>
            AppStartBloc(AppStartRepoDummy(storage))
              ..add(const AppStartStarted()),
      ),

      BlocProvider(
        create: (_) =>
            LanguageBloc(LanguageService(storage))
              ..add(const LanguageStarted()),
      ),

    ],
    child: MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(langState.code),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.btnPrimary,
                foregroundColor: AppColors.btnPrimaryText,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnPrimary,
                foregroundColor: AppColors.btnPrimaryText,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: AppRoot.withBloc(),
        );
      },
    );
  }
}
*/
