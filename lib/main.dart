import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'services/localization_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'features/onboarding/bloc/onboarding_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'features/onboarding/bloc/onboarding_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingBloc()..add(const OnboardingStarted())),
      ],
      child: const App(),
    ),
  );
}
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

class MyApp extends StatelessWidget {
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
}

