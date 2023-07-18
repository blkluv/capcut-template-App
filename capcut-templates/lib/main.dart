import 'package:capcut_template/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
      statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
      statusBarColor: AppThemeColor.backGroundColor, // status bar color
      systemNavigationBarColor:
          AppThemeColor.backGroundColor, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
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
