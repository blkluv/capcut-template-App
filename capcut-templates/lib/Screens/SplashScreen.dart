import 'dart:async';

import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Images.dart';
import 'package:capcut_template/Utils/Toast.dart';
import 'package:flutter/material.dart';

import '../Api/ApiHelper.dart';
import '../Utils/Router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
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
            RouterClass()
                .homeScreenRoute(context: context, settings: _settings!);
          });
        } else {
          ShowToast().showNormalToast(msg: 'Some thing going wrong!');
        }
      }
    });
  }

  late AnimationController logoAnimation;

  _handleAnimation() {
    logoAnimation = AnimationController(
      upperBound: 500,
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    logoAnimation.forward();
    logoAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    _getSettings();
    _handleAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      width: screenWidth,
      height: screenHeight,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        gradient: AppThemeColor.backgroundGradient1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.inAppLogo,
            width: logoAnimation.value,
          ),
        ],
      ),
    );
  }
}
