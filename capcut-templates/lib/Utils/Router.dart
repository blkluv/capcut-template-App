import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Models/TemplateObject.dart';
import 'package:capcut_template/Screens/LikedScreen.dart';
import 'package:capcut_template/Screens/SingleTemplateScreen.dart';
import 'package:flutter/material.dart';

import '../Screens/HomeScreen.dart';

class RouterClass {
  homeScreenRoute(
          {required BuildContext context, required Settings settings}) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            settings: settings,
          ),
        ),
      );

  singleTemplateScreenRoute(
          {required BuildContext context,
          required Settings settings,
          required TemplateObject template}) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleTemplateScreen(
            settings: settings,
            template: template,
          ),
        ),
      );

  likedTemplateScreenRoute({
    required BuildContext context,
    required Settings settings,
  }) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LikedScreen(
            settings: settings,
          ),
        ),
      );
}
