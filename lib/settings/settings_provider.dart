import 'package:flutter/material.dart';

import '../main.dart';

class SettingsProvider {
  SettingsProvider({required this.callbackOnSettingsChange}) {
    bool? test = globalPrefs.getBool("showDots");
    if (test != null) {
      _showDots = test;
    }
    test = globalPrefs.getBool("showBelowBarData");
    if (test != null) {
      _showBelowBarData = test;
    }
    test = globalPrefs.getBool("showXAxis");
    if (test != null) {
      _showXAxis = test;
    }
    double? dValue = globalPrefs.getDouble("maxOnYAxis");
    if (dValue != null) {
      _maxOnYAxis = dValue;
    }
    String? sValue = globalPrefs.getString("themeModeAsString");
    if (sValue != null) {
      _themeModeAsString = sValue;
    }
  }

  final Function() callbackOnSettingsChange;

  bool _showDots = true;
  bool get showDots => _showDots;
  set showDots(bool value) {
    if (value != _showDots) {
      _showDots = value;
      globalPrefs.setBool("showDots", value);
      callbackOnSettingsChange();
    }
  }

  bool _showBelowBarData = true;
  bool get showBelowBarData => _showBelowBarData;
  set showBelowBarData(bool value) {
    if (value != _showBelowBarData) {
      _showBelowBarData = value;
      globalPrefs.setBool("showBelowBarData", value);
      callbackOnSettingsChange();
    }
  }

  bool _showXAxis = true;
  bool get showXAxis => _showXAxis;
  set showXAxis(bool value) {
    if (value != _showXAxis) {
      _showXAxis = value;
      globalPrefs.setBool("showXAxis", value);
      callbackOnSettingsChange();
    }
  }

  double _maxOnYAxis = 2000;
  double get maxOnYAxis => _maxOnYAxis;
  set maxOnYAxis(double value) {
    if ((value - _maxOnYAxis).abs() > 0.01) {
      _maxOnYAxis = value;
      globalPrefs.setDouble("maxOnYAxis", value);
      callbackOnSettingsChange();
    }
  }

  String _themeModeAsString = "system";
  String get themeModeAsString => _themeModeAsString;
  set themeModeAsString(String value) {
    if (value != _themeModeAsString) {
      _themeModeAsString = value;
      globalPrefs.setString("themeModeAsString", value);
      callbackOnSettingsChange();
    }
  }

  ThemeMode get themeMode {
    var result = ThemeMode.system;
    if (_themeModeAsString == "light") {
      result = ThemeMode.light;
    }
    if (_themeModeAsString == "dark") {
      result = ThemeMode.dark;
    }
    return result;
  }
}
