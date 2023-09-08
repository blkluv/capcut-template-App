import 'dart:async';

import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Images.dart';
import 'package:capcut_template/Utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Api/ApiHelper.dart';
import '../Utils/Router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double screenWidth = 1000;
  double screenHeight = 1000;

  Settings? _settings;
  bool _loading = true;
  Future<void> _getSettings() async {
    print('m Called');

    await ApiHelper().getSettings().then((settingsData) {
      if (settingsData != null) {
        print(settingsData['setting']);
        setState(() {
          _settings = Settings.fromJson(settingsData['setting']);
          _loading = false;
        });

        if (_settings != null) {
          Timer(const Duration(seconds: 3), () {
            RouterClass().homeScreenRoute(context: context, settings: _settings!);
          });
        } else {
          ShowToast().showNormalToast(msg: 'Some thing going wrong!');
        }
      }
    });
  }

  @override
  void initState() {
    _getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return AnimationLimiter(
      child: AnimationConfiguration.staggeredList(
        duration: const Duration(milliseconds: 1500),
        position: 3,
        child: ScaleAnimation(
          duration: const Duration(seconds: 2),
          child: FadeInAnimation(
            duration: const Duration(seconds: 2),
            delay: const Duration(milliseconds: 350),
            child: Center(
              child: Image.asset(Images.inAppLogo, width: 150),
            ),
          ),
        ),
      ),
    );
  }
}
