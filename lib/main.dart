// ============================================================
// CATATAN: File ini adalah ENTRY POINT baru dengan Provider.
// File lama telah digantikan oleh struktur folder berikut:
//   lib/
//   ├── main.dart                  ← entry point (file ini)
//   ├── models/temp_unit.dart      ← enum & extension TempUnit
//   ├── utils/temperature_converter_service.dart  ← logika konversi
//   ├── providers/temperature_provider.dart       ← state management
//   ├── screens/converter_screen.dart             ← layar utama
//   └── widgets/
//       ├── thermometer_visual.dart
//       ├── unit_selector.dart
//       ├── result_card.dart
//       └── quick_reference.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/temperature_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const TemperatureApp());
}

class TemperatureApp extends StatelessWidget {
  const TemperatureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TemperatureProvider()),
      ],
      child: MaterialApp(
        title: 'Konversi Suhu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Nunito',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B35),
            brightness: Brightness.dark,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
