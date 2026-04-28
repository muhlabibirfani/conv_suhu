import 'package:flutter/material.dart';
import '../models/temp_unit.dart';
import '../utils/temperature_converter_service.dart';

/// [TemperatureProvider] menyimpan seluruh state konversi suhu.
/// Widget hanya perlu `context.watch` / `context.read` — tidak ada setState.
class TemperatureProvider extends ChangeNotifier {
  // ── State ────────────────────────────────────────────────────────────────

  TempUnit _fromUnit = TempUnit.celsius;
  TempUnit _toUnit = TempUnit.fahrenheit;
  double? _inputValue;
  Map<TempUnit, double> _allResults = {};

  // ── Getters ──────────────────────────────────────────────────────────────

  TempUnit get fromUnit => _fromUnit;
  TempUnit get toUnit => _toUnit;
  double? get inputValue => _inputValue;

  /// Hasil konversi ke satuan [toUnit]. Null jika belum ada input.
  double? get result =>
      _inputValue != null ? _allResults[_toUnit] : null;

  /// Semua hasil konversi (untuk mini-display).
  Map<TempUnit, double> get allResults => _allResults;

  /// Celsius hasil input (dipakai untuk thermometer & deskripsi).
  double get celsiusValue =>
      _inputValue != null
          ? TemperatureConverterService.toCelsius(_inputValue!, _fromUnit)
          : 0.0;

  String get description =>
      TemperatureConverterService.getDescription(celsiusValue);

  // ── Actions ──────────────────────────────────────────────────────────────

  /// Dipanggil saat pengguna mengetik di TextField.
  void onInputChanged(String text) {
    final trimmed = text.trim().replaceAll(',', '.');
    if (trimmed.isEmpty) {
      _inputValue = null;
      _allResults = {};
    } else {
      final parsed = double.tryParse(trimmed);
      if (parsed != null) {
        _inputValue = parsed;
        _allResults = TemperatureConverterService.convertAll(parsed, _fromUnit);
      }
    }
    notifyListeners();
  }

  /// Ubah satuan asal.
  void setFromUnit(TempUnit unit) {
    if (_fromUnit == unit) return;
    _fromUnit = unit;
    _recalculate();
    notifyListeners();
  }

  /// Ubah satuan tujuan.
  void setToUnit(TempUnit unit) {
    if (_toUnit == unit) return;
    _toUnit = unit;
    notifyListeners();
  }

  /// Tukar satuan asal ↔ tujuan.
  void swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    _recalculate();
    notifyListeners();
  }

  /// Set input dari referensi cepat.
  void setFromReference(double celsius) {
    _inputValue = TemperatureConverterService.fromCelsius(celsius, _fromUnit);
    _allResults = TemperatureConverterService.convertAll(_inputValue!, _fromUnit);
    notifyListeners();
  }

  // ── Private ──────────────────────────────────────────────────────────────

  void _recalculate() {
    if (_inputValue == null) return;
    _allResults = TemperatureConverterService.convertAll(_inputValue!, _fromUnit);
  }

  // ── Helpers (delegasi ke service) ────────────────────────────────────────

  String format(double value) =>
      TemperatureConverterService.formatValue(value);

  double refFromValue(double celsius) =>
      TemperatureConverterService.fromCelsius(celsius, _fromUnit);

  double refToValue(double celsius) =>
      TemperatureConverterService.fromCelsius(celsius, _toUnit);
}
