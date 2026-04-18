import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/app_root.dart';
import 'core/di/app_injector.dart';
import 'core/navigation/app_navigator.dart';
import 'features/app_start/bloc/app_start_event.dart';
import 'features/language/bloc/language_event.dart';
import 'features/language/bloc/language_state.dart';
import 'theme/app_colors.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/language/bloc/language_bloc.dart';
import 'features/app_start/bloc/app_start_bloc.dart';
import 'features/internet/bloc/internet_bloc.dart';
import 'features/internet/bloc/internet_event.dart';
import 'features/internet/bloc/internet_state.dart';
import 'features/internet/view/no_internet_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjector();
  FlutterError.onError = FlutterError.presentError;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AppStartBloc>()..add(const AppStartStarted()),
        ),
        BlocProvider<LanguageBloc>(
          create: (_) => getIt<LanguageBloc>()..add(const LanguageStarted()),
        ),
        BlocProvider<InternetBloc>(
          create: (_) => getIt<InternetBloc>()..add(const CheckConnection()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _seedGazaSpacesOnce() async {
  final db = FirebaseFirestore.instance;
  final markerRef = db.collection('app_meta').doc('seed_gaza_spaces_v1');
  final marker = await markerRef.get();
  if (marker.exists) return;

  final spaces = _gazaSpacesSeedData();
  final batch = db.batch();
  var created = 0;

  for (final space in spaces) {
    final id = space['id'] as String;
    final ref = db.collection('spaces').doc(id);
    final existing = await ref.get();
    if (existing.exists) continue;

    final data = Map<String, dynamic>.from(space)..remove('id');
    batch.set(ref, data);
    created++;
  }

  if (created > 0) {
    await batch.commit();
  }

  await markerRef.set({
    'createdCount': created,
    'totalTemplateCount': spaces.length,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

List<Map<String, dynamic>> _gazaSpacesSeedData() {
  const defaultAmenities = [
    {'id': 'a1', 'name': 'WiFi', 'selected': true, 'isCustom': false},
    {'id': 'a2', 'name': 'Electricity', 'selected': true, 'isCustom': false},
    {'id': 'a3', 'name': 'Meeting Room', 'selected': true, 'isCustom': false},
    {'id': 'a4', 'name': 'Coffee', 'selected': true, 'isCustom': false},
    {'id': 'a5', 'name': 'Parking', 'selected': true, 'isCustom': false},
    {'id': 'a6', 'name': 'Printer', 'selected': true, 'isCustom': false},
  ];

  const workingHours = [
    {'day': 'Sun', 'open': '08:00', 'close': '21:00', 'closed': false},
    {'day': 'Mon', 'open': '08:00', 'close': '21:00', 'closed': false},
    {'day': 'Tue', 'open': '08:00', 'close': '21:00', 'closed': false},
    {'day': 'Wed', 'open': '08:00', 'close': '21:00', 'closed': false},
    {'day': 'Thu', 'open': '08:00', 'close': '21:00', 'closed': false},
    {'day': 'Fri', 'open': '14:00', 'close': '22:00', 'closed': false},
    {'day': 'Sat', 'open': '10:00', 'close': '20:00', 'closed': false},
  ];

  const policySections = [
    {
      'id': 'p1',
      'title': 'General',
      'bullets': [
        'No loud calls in shared area',
        'Keep workspace clean',
        'Smoking is prohibited indoors',
      ],
    },
    {
      'id': 'p2',
      'title': 'Meeting Rooms',
      'bullets': [
        'Booking required in advance',
        'Max 2 hours per reservation',
      ],
    },
  ];

  const paymentMethods = [
    {
      'id': 'bank_transfer',
      'name': 'Bank Transfer',
      'accountName': 'Msahtak Workspace',
      'accountDetails': 'Bank of Palestine - IBAN: PS00 1234 5678 9012',
    },
    {
      'id': 'jawwal_pay',
      'name': 'Jawwal Pay',
      'accountName': 'Msahtak Wallet',
      'accountDetails': '+970599000000',
    },
  ];

  Map<String, dynamic> space({
    required String id,
    required String name,
    required String subtitle,
    required String description,
    required String city,
    required String address,
    required double lat,
    required double lng,
    required int pricePerDay,
    required int totalSeats,
    required double rating,
    required int reviewsCount,
    required List<String> tags,
  }) {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'description': description,
      'address': address,
      'location_address': '$address, $city, Gaza',
      'location': {
        'lat': lat,
        'lng': lng,
        'city': city,
        'address': address,
      },
      'currency': '₪',
      'basePriceValue': pricePerDay,
      'basePriceUnit': 'day',
      'pricePerDay': pricePerDay,
      'price_per_day': pricePerDay,
      'rating': rating,
      'reviews_count': reviewsCount,
      'tags': tags,
      'images': [
        'https://images.unsplash.com/photo-1497366216548-37526070297c',
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72',
      ],
      'features': [
        'High-speed internet',
        'Quiet work zones',
        'Private meeting room',
        'Power backup',
      ],
      'amenities': defaultAmenities,
      'workingHours': workingHours,
      'policySections': policySections,
      'paymentMethods': paymentMethods,
      'totalSeats': totalSeats,
      'availableSeats': totalSeats,
      'hidden': false,
      'usage_stats': [
        {'label': 'Students', 'percent': 35},
        {'label': 'Freelancers', 'percent': 40},
        {'label': 'Startups', 'percent': 25},
      ],
      'why_people_come': [
        'Reliable electricity',
        'Strong Wi-Fi',
        'Quiet environment',
      ],
      'review_summary': {
        'header': '$rating ★',
        'meta': 'Based on $reviewsCount reviews',
        'top_positives': ['Fast internet', 'Clean space', 'Friendly staff'],
        'repeated_negatives': ['Limited parking in peak hours'],
        'crowd_level': 'Moderate',
        'noise': 'Low',
      },
      'latest_reviews': [
        {
          'id': 'r1',
          'user_name': 'Ahmad',
          'time_ago': '2 days ago',
          'stars': 5,
          'comment': 'Great place for deep focus and remote work.',
        },
        {
          'id': 'r2',
          'user_name': 'Mona',
          'time_ago': '1 week ago',
          'stars': 4,
          'comment': 'Comfortable and organized workspace.',
        },
      ],
      'offers': [
        {
          'id': 'off1',
          'badge_text': 'LIMITED',
          'badge_type': 'limited',
          'title': 'Weekly Pass',
          'price_line': 'Price:',
          'old_price_text': null,
          'new_price_text': '₪${(pricePerDay * 6)} / week',
          'includes_text': 'Includes 7-day access + 2 meeting room hours',
          'valid_until_text': 'Valid through this month',
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  return [
    space(
      id: 'GZA-SP-001',
      name: 'Gaza Sky Hub',
      subtitle: 'Downtown co-working for focus and teams',
      description: 'Modern workspace near Gaza city center for study and work.',
      city: 'Gaza City',
      address: 'Omar Al-Mukhtar St',
      lat: 31.5225,
      lng: 34.4532,
      pricePerDay: 70,
      totalSeats: 42,
      rating: 4.7,
      reviewsCount: 118,
      tags: ['wifi', 'quiet', 'meeting', 'central'],
    ),
    space(
      id: 'GZA-SP-002',
      name: 'Rimal Work Loft',
      subtitle: 'Quiet desks with premium internet',
      description: 'A calm workspace in Al-Rimal district with private booths.',
      city: 'Gaza City',
      address: 'Al-Rimal, Al-Jalaa St',
      lat: 31.5293,
      lng: 34.4581,
      pricePerDay: 65,
      totalSeats: 30,
      rating: 4.6,
      reviewsCount: 84,
      tags: ['wifi', 'study', 'quiet'],
    ),
    space(
      id: 'GZA-SP-003',
      name: 'Shifa Innovation Space',
      subtitle: 'Startup-friendly collaborative floor',
      description: 'Open collaboration area plus meeting rooms for small teams.',
      city: 'Gaza City',
      address: 'Al-Nasr St',
      lat: 31.5321,
      lng: 34.4667,
      pricePerDay: 60,
      totalSeats: 36,
      rating: 4.5,
      reviewsCount: 73,
      tags: ['startup', 'team', 'wifi'],
    ),
    space(
      id: 'GZA-SP-004',
      name: 'Khan Younis Study Lounge',
      subtitle: 'Student-first workspace',
      description: 'Affordable desks and extended evening hours for students.',
      city: 'Khan Younis',
      address: 'Jalal St',
      lat: 31.3469,
      lng: 34.3039,
      pricePerDay: 45,
      totalSeats: 28,
      rating: 4.4,
      reviewsCount: 66,
      tags: ['students', 'budget', 'quiet'],
    ),
    space(
      id: 'GZA-SP-005',
      name: 'Mawasi Remote Base',
      subtitle: 'Remote-work ready with backup power',
      description: 'Reliable internet and generator-backed power for remote teams.',
      city: 'Khan Younis',
      address: 'Mawasi Road',
      lat: 31.3285,
      lng: 34.2574,
      pricePerDay: 55,
      totalSeats: 24,
      rating: 4.5,
      reviewsCount: 52,
      tags: ['remote', 'power', 'wifi'],
    ),
    space(
      id: 'GZA-SP-006',
      name: 'Deir Al-Balah WorkPoint',
      subtitle: 'Balanced space for focus and meetings',
      description: 'Comfortable seats with smart booking for meeting rooms.',
      city: 'Deir al-Balah',
      address: 'Salah Al-Din Rd',
      lat: 31.4177,
      lng: 34.3503,
      pricePerDay: 50,
      totalSeats: 26,
      rating: 4.3,
      reviewsCount: 49,
      tags: ['meeting', 'wifi', 'focus'],
    ),
    space(
      id: 'GZA-SP-007',
      name: 'Nuseirat Tech Corner',
      subtitle: 'Tech-enabled desks for creators',
      description: 'Designed for developers and creatives with long-hour access.',
      city: 'Nuseirat',
      address: 'Camp Market St',
      lat: 31.4478,
      lng: 34.3902,
      pricePerDay: 52,
      totalSeats: 22,
      rating: 4.4,
      reviewsCount: 41,
      tags: ['tech', 'creative', 'wifi'],
    ),
    space(
      id: 'GZA-SP-008',
      name: 'Jabalia Focus Center',
      subtitle: 'Community workspace for deep focus',
      description: 'A practical and affordable workspace with stable connectivity.',
      city: 'Jabalia',
      address: 'Main Market St',
      lat: 31.5386,
      lng: 34.4951,
      pricePerDay: 48,
      totalSeats: 25,
      rating: 4.2,
      reviewsCount: 39,
      tags: ['community', 'quiet', 'study'],
    ),
    space(
      id: 'GZA-SP-009',
      name: 'Rafah Business Desk',
      subtitle: 'Professional setup for business users',
      description: 'Dedicated workspace with private corners for client calls.',
      city: 'Rafah',
      address: 'Al-Bahr St',
      lat: 31.2978,
      lng: 34.2432,
      pricePerDay: 58,
      totalSeats: 20,
      rating: 4.3,
      reviewsCount: 44,
      tags: ['business', 'calls', 'meeting'],
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppNavigator.key,
          locale: Locale(langState.code),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
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

          home: BlocBuilder<InternetBloc, InternetState>(
            builder: (context, internetState) {
              if (internetState is InternetDisconnected) {
                return NoInternetScreen(
                  onRetry: () => context.read<InternetBloc>().add(const CheckConnection()),
                );
              }
              return AppRoot.withBloc();
            },
          ),
        );
      },
    );
  }
}
