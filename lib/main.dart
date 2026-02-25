import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masahtak_app/features/app_start/data/repos/app_start_repo_dummy.dart';

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
  final languageService = LanguageService(storage);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepoDummy(LocalStorageService())),
        ),
        BlocProvider(
          create: (_) =>
              AppStartBloc(AppStartRepoDummy(LocalStorageService()))
                ..add(const AppStartStarted()),
        ),
        BlocProvider(
          create: (_) =>
              LanguageBloc(LanguageService(LocalStorageService()))
                ..add(const LanguageStarted()),
        ),
        BlocProvider<LanguageBloc>(
          create: (_) =>
              LanguageBloc(languageService)..add(const LanguageStarted()),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
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
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
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

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'app/app_root.dart';
import 'features/session/bloc/session_bloc.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SessionBloc()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: localization.currentLocale,

          // لو عندك delegates/supportedLocales ضيفيهم
          // supportedLocales: const [Locale('en'), Locale('ar')],
          // localizationsDelegates: const [...],

          home: const AppRoot(),
        );
      },
    );
  }
}*/

/*

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocalizationService(),
      child: const MyApp(),
    ),
  );
}*/

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localizationService, child) {
        return MaterialApp(
          title: 'Msahtak',
          debugShowCheckedModeBanner: false,
          locale: localizationService.currentLocale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primaryColor: const Color(0xFF5B8FB9),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}*/
