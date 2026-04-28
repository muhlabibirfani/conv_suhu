import 'package:flutter/material.dart';

enum TempUnit { celsius, fahrenheit, kelvin, rankine }

extension TempUnitExt on TempUnit {
  String get symbol {
    switch (this) {
      case TempUnit.celsius:
        return '°C';
      case TempUnit.fahrenheit:
        return '°F';
      case TempUnit.kelvin:
        return 'K';
      case TempUnit.rankine:
        return '°R';
    }
  }

  String get label {
    switch (this) {
      case TempUnit.celsius:
        return 'Celsius';
      case TempUnit.fahrenheit:
        return 'Fahrenheit';
      case TempUnit.kelvin:
        return 'Kelvin';
      case TempUnit.rankine:
        return 'Rankine';
    }
  }

  Color get color {
    switch (this) {
      case TempUnit.celsius:
        return const Color(0xFF4FC3F7);
      case TempUnit.fahrenheit:
        return const Color(0xFFFF7043);
      case TempUnit.kelvin:
        return const Color(0xFFAB47BC);
      case TempUnit.rankine:
        return const Color(0xFF66BB6A);
    }
  }

  IconData get icon {
    switch (this) {
      case TempUnit.celsius:
        return Icons.ac_unit;
      case TempUnit.fahrenheit:
        return Icons.local_fire_department;
      case TempUnit.kelvin:
        return Icons.science;
      case TempUnit.rankine:
        return Icons.thermostat;
    }
  }
}
