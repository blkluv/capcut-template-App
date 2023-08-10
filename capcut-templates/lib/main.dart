import 'dart:developer';

import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/add_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'Screens/SplashScreen.dart';

FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  await _analytics.setAnalyticsCollectionEnabled(true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddProvider()),
      ],
      child: const MyApp(),
    ),
  );
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("bdf832c9-03af-4b7d-8cee-e827f9c440b0");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
      statusBarColor: AppThemeColor.backGroundColor, // status bar color
      systemNavigationBarColor: AppThemeColor.backGroundColor, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    _initGoogleMobileAds().then((value) => log('Google Mobile Ads Initialized: ${value.adapterStatuses}'));
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    log('_initGoogleMobileAds');
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.nunitoSans().fontFamily,
      ),
      home: const SplashScreen(),
    );
  }
}
