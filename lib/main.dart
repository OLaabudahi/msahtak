import 'package:Msahtak/features/auth/domain/usecases/forgot_usecase.dart';
import 'package:Msahtak/features/auth/domain/usecases/login_usecase.dart';
import 'package:Msahtak/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:Msahtak/features/auth/domain/usecases/signup_usecase.dart';
import 'package:Msahtak/services/language_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/app_root.dart';
import 'features/app_start/data/repos/app_start_repo_firebase.dart';
import 'features/auth/data/repos/auth_repo_firebase.dart';
import 'features/auth/data/sources/auth_firebase_source.dart';
import 'features/auth/domain/usecases/logout_auth_usecase.dart';
import 'firebase_options.dart';
import 'theme/app_colors.dart';
import 'features/app_start/bloc/app_start_event.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/app_start/bloc/app_start_bloc.dart';
import 'features/language/bloc/language_event.dart';
import 'features/language/bloc/language_state.dart';
import 'services/language_service.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    // ignore: avoid_print
    print('FlutterError: ${details.exceptionAsString()}\n${details.stack}');
  };
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    // ignore: avoid_print
    print('Firebase init error: $e\n$st');
    return;
  }
/*
  try {
    await _seedspacesIfEmpty();
  } catch (_) {}
*/

  final storage = LocalStorageService();
  final languageService = LanguageService(storage);
  final repo = AuthRepoFirebase(LocalStorageService());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(repo),
            signUpUseCase:SignUpUseCase(repo),
            forgotUseCase:ForgotPasswordUseCase(repo),
            logoutUseCase:LogoutAuthUseCase(repo),
            googleUseCase: LoginWithGoogleUseCase(repo),
          ),
        ),
        BlocProvider(
          create: (_) =>
              AppStartBloc(AppStartRepoFirebase(LocalStorageService()))
                ..add(const AppStartStarted()),
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

/// تضيف مساحات عمل تجريبية إذا كانت workspaces فارغة
Future<void> _seedWorkspacesIfEmpty() async {
  final col = FirebaseFirestore.instance.collection('workspaces');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return; // الداتا موجودة — لا شيء

 /* final spaces = [
    {
      'name': 'The Hub Workspace',
      'subtitle': 'Modern coworking · Ramallah',
      'rating': 4.8,
      'price_per_day': 120,
      'currency': '₪',
      'location': const GeoPoint(31.9038, 35.2034),
      'location_address': 'Al-Masyoun St, Ramallah',
      'working_hours': 'Sun – Thu: 8:00 AM – 10:00 PM',
      'tags': ['Wi-Fi', 'Quiet', 'Parking', 'Coffee'],
      'reviews_count': 42,
      'images': <String>[],
      'features': [
        'High-speed Wi-Fi (500 Mbps)',
        'Private meeting rooms',
        'Coffee & snacks included',
        'Standing desks available',
        'Printer & scanner',
      ],
      'usage_stats': [
        {'label': 'Freelancers', 'percent': 45},
        {'label': 'Startups', 'percent': 30},
        {'label': 'Students', 'percent': 15},
        {'label': 'Remote teams', 'percent': 10},
      ],
      'why_people_come': ['Fast Wi-Fi', 'Quiet environment', 'Good coffee', 'Central location'],
      'review_summary': {
        'header': '4.8 ★',
        'meta': 'Based on 42 reviews',
        'top_positives': ['Excellent Wi-Fi', 'Very clean', 'Helpful staff'],
        'repeated_negatives': ['Parking can be limited'],
        'crowd_level': 'Moderate',
        'noise': 'Quiet',
      },
      'latest_reviews': [
        {
          'id': 'r1',
          'user_name': 'Sana K.',
          'time_ago': '2 days ago',
          'stars': 5,
          'comment': 'Amazing place to work! Fast internet and great atmosphere.',
        },
        {
          'id': 'r2',
          'user_name': 'Omar A.',
          'time_ago': '1 week ago',
          'stars': 5,
          'comment': 'Best coworking space in Ramallah. Highly recommend!',
        },
      ],
      'offers': [
        {
          'id': 'off1',
          'badge_text': 'LIMITED',
          'badge_type': 'limited',
          'title': 'Monthly Pass',
          'price_line': 'Price:',
          'old_price_text': '₪2,800',
          'new_price_text': '₪2,200 / month',
          'includes_text': 'Includes unlimited access + 4 meeting room hours',
          'valid_until_text': 'Valid until end of month',
        },
      ],
      'policies': {
        'title': 'House Rules',
        'subtitle': 'Please respect all members',
        'sections': [
          {
            'title': 'General',
            'bullets': [
              'No loud phone calls in open area',
              'Clean your desk before leaving',
              'Guests must register at reception',
            ],
          },
          {
            'title': 'Meeting Rooms',
            'bullets': [
              'Book in advance via the app',
              'Max 2-hour sessions per booking',
            ],
          },
        ],
      },
    },
    {
      'name': 'Nablus Creative Space',
      'subtitle': 'Creative studio · Nablus',
      'rating': 4.6,
      'price_per_day': 90,
      'currency': '₪',
      'location': const GeoPoint(32.2211, 35.2544),
      'location_address': 'Rafidya, Nablus',
      'working_hours': 'Daily: 9:00 AM – 9:00 PM',
      'tags': ['Wi-Fi', 'Creative', 'Lounge'],
      'reviews_count': 28,
      'images': <String>[],
      'features': [
        'Design-friendly environment',
        'Large monitors available',
        'Lounge area',
        'Whiteboards & projectors',
      ],
      'usage_stats': [
        {'label': 'Designers', 'percent': 50},
        {'label': 'Developers', 'percent': 30},
        {'label': 'Others', 'percent': 20},
      ],
      'why_people_come': ['Creative vibe', 'Good equipment', 'Affordable price'],
      'review_summary': {
        'header': '4.6 ★',
        'meta': 'Based on 28 reviews',
        'top_positives': ['Great design tools', 'Friendly community'],
        'repeated_negatives': ['No parking nearby'],
        'crowd_level': 'Low',
        'noise': 'Moderate',
      },
      'latest_reviews': [
        {
          'id': 'r3',
          'user_name': 'Lina M.',
          'time_ago': '3 days ago',
          'stars': 5,
          'comment': 'Perfect for designers. The equipment is top notch.',
        },
      ],
      'offers': <Map<String, dynamic>>[],
      'policies': {
        'title': 'Space Rules',
        'subtitle': '',
        'sections': [
          {
            'title': 'Usage',
            'bullets': [
              'Equipment must be returned after use',
              'No food near design equipment',
            ],
          },
        ],
      },
    },
    {
      'name': 'Birzeit Tech Hub',
      'subtitle': 'Tech-focused · Birzeit',
      'rating': 4.5,
      'price_per_day': 80,
      'currency': '₪',
      'location': const GeoPoint(31.9800, 35.1900),
      'location_address': 'Main St, Birzeit',
      'working_hours': 'Sun – Thu: 8:00 AM – 8:00 PM',
      'tags': ['Wi-Fi', 'Tech', 'Quiet', 'Coffee'],
      'reviews_count': 19,
      'images': <String>[],
      'features': [
        'Gigabit fiber internet',
        'Server room access',
        'Standing desk pods',
        'Coffee & tea',
      ],
      'usage_stats': [
        {'label': 'Developers', 'percent': 60},
        {'label': 'Startups', 'percent': 25},
        {'label': 'Students', 'percent': 15},
      ],
      'why_people_come': ['Blazing fast internet', 'Focused environment', 'Tech community'],
      'review_summary': {
        'header': '4.5 ★',
        'meta': 'Based on 19 reviews',
        'top_positives': ['Best internet speed', 'Quiet and focused'],
        'repeated_negatives': ['Limited seating'],
        'crowd_level': 'Low',
        'noise': 'Very quiet',
      },
      'latest_reviews': [
        {
          'id': 'r4',
          'user_name': 'Ahmed T.',
          'time_ago': '5 days ago',
          'stars': 5,
          'comment': 'The internet speed here is unmatched. Great for developers.',
        },
      ],
      'offers': <Map<String, dynamic>>[],
      'policies': {
        'title': 'Rules',
        'subtitle': 'Keep the environment productive',
        'sections': [
          {
            'title': 'General',
            'bullets': [
              'Silence your phone',
              'Use headphones for calls',
            ],
          },
        ],
      },
    },
    {
      'name': 'Bethlehem Business Hub',
      'subtitle': 'Professional space · Bethlehem',
      'rating': 4.7,
      'price_per_day': 100,
      'currency': '₪',
      'location': const GeoPoint(31.7054, 35.2024),
      'location_address': 'Star St, Bethlehem',
      'working_hours': 'Sun – Fri: 8:00 AM – 9:00 PM',
      'tags': ['Wi-Fi', 'Professional', 'Quiet', 'Meeting Rooms'],
      'reviews_count': 35,
      'images': <String>[],
      'features': [
        'Premium Wi-Fi',
        'Dedicated desks',
        '3 private meeting rooms',
        'Printing & scanning',
        'Reception services',
      ],
      'usage_stats': [
        {'label': 'Consultants', 'percent': 40},
        {'label': 'Remote workers', 'percent': 35},
        {'label': 'Startups', 'percent': 25},
      ],
      'why_people_come': ['Professional setting', 'Meeting rooms', 'Central location'],
      'review_summary': {
        'header': '4.7 ★',
        'meta': 'Based on 35 reviews',
        'top_positives': ['Professional atmosphere', 'Excellent facilities'],
        'repeated_negatives': ['Can get busy on weekdays'],
        'crowd_level': 'Moderate',
        'noise': 'Quiet',
      },
      'latest_reviews': [
        {
          'id': 'r5',
          'user_name': 'Rania S.',
          'time_ago': '1 day ago',
          'stars': 5,
          'comment': 'Great professional environment. Meeting rooms are perfect.',
        },
      ],
      'offers': [
        {
          'id': 'off2',
          'badge_text': 'NEW',
          'badge_type': 'new',
          'title': 'Weekly Pass',
          'price_line': 'Price:',
          'old_price_text': null,
          'new_price_text': '₪450 / week',
          'includes_text': 'Includes 5 days access + 2 meeting room hours',
          'valid_until_text': 'No expiry',
        },
      ],
      'policies': {
        'title': 'Business Hub Rules',
        'subtitle': 'Maintain a professional environment',
        'sections': [
          {
            'title': 'Conduct',
            'bullets': [
              'Business attire recommended',
              'Keep noise to a minimum',
              'Meetings by appointment only in shared areas',
            ],
          },
        ],
      },
    },
  ];*/

 /* for (final w in spaces) {
    await col.add(w);
  }*/
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
            // ── NavigationBar: أيقونة ونص المختار = أزرق ──────────────
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: AppColors.background,
              indicatorColor: Colors.transparent,
              iconTheme: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const IconThemeData(color: AppColors.navSelected);
                }
                return const IconThemeData(color: AppColors.textSecondary);
              }),
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(
                    color: AppColors.navSelected,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  );
                }
                return const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                );
              }),
            ),
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
