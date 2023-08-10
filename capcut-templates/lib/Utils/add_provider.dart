import 'package:flutter/material.dart';

class AddProvider extends ChangeNotifier {
  int _addPlayCount = 0;
  int get addPlayCount => _addPlayCount;

  void playAdd() {
    _addPlayCount++;
    notifyListeners();
  }

  bool checkIfIsPlayAdd() {
    if (_addPlayCount == 0 || _addPlayCount == 5 ) {
      _addPlayCount = 0;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
