import '../models/temp_unit.dart';

/// Pure utility class — tidak bergantung pada Flutter/UI.
/// Bertanggung jawab hanya untuk logika konversi suhu.
class TemperatureConverterService {
  const TemperatureConverterService._();

  /// Konversi nilai ke Celsius sebagai pivot tengah.
  static double toCelsius(double value, TempUnit from) {
    switch (from) {
      case TempUnit.celsius:
        return value;
      case TempUnit.fahrenheit:
        return (value - 32) * 5 / 9;
      case TempUnit.kelvin:
        return value - 273.15;
      case TempUnit.rankine:
        return (value - 491.67) * 5 / 9;
    }
  }

  /// Konversi dari Celsius ke satuan target.
  static double fromCelsius(double celsius, TempUnit to) {
    switch (to) {
      case TempUnit.celsius:
        return celsius;
      case TempUnit.fahrenheit:
        return celsius * 9 / 5 + 32;
      case TempUnit.kelvin:
        return celsius + 273.15;
      case TempUnit.rankine:
        return (celsius + 273.15) * 9 / 5;
    }
  }

  /// Konversi langsung dari satuan [from] ke satuan [to].
  static double convert(double value, TempUnit from, TempUnit to) {
    final celsius = toCelsius(value, from);
    return fromCelsius(celsius, to);
  }

  /// Konversi ke semua satuan sekaligus. Berguna untuk tampilan hasil lengkap.
  static Map<TempUnit, double> convertAll(double value, TempUnit from) {
    final celsius = toCelsius(value, from);
    return {
      for (final unit in TempUnit.values) unit: fromCelsius(celsius, unit),
    };
  }

  /// Deskripsi kondisi berdasarkan suhu Celsius.
  static String getDescription(double celsius) {
    if (celsius <= -40) return '❄️ Sangat Dingin Ekstrem';
    if (celsius <= 0) return '🧊 Di Bawah Titik Beku';
    if (celsius <= 10) return '🌨️ Dingin';
    if (celsius <= 20) return '🌤️ Sejuk';
    if (celsius <= 30) return '☀️ Nyaman';
    if (celsius <= 40) return '🌡️ Hangat';
    if (celsius <= 60) return '🔥 Panas';
    return '🌋 Sangat Panas Ekstrem';
  }

  /// Format angka agar tampil rapi (tanpa desimal nol di belakang).
  static String formatValue(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
