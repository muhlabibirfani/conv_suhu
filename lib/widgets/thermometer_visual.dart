import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temperature_provider.dart';
import '../models/temp_unit.dart';

/// Menampilkan visual thermometer animasi + hasil konversi utama.
/// Membaca [TemperatureProvider] secara mandiri (watch).
class ThermometerVisual extends StatefulWidget {
  const ThermometerVisual({super.key});

  @override
  State<ThermometerVisual> createState() => _ThermometerVisualState();
}

class _ThermometerVisualState extends State<ThermometerVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _tempColor(double celsius) {
    if (celsius <= 0) return const Color(0xFF4FC3F7);
    if (celsius <= 30) return const Color(0xFF66BB6A);
    if (celsius <= 60) return const Color(0xFFFFB74D);
    return const Color(0xFFFF5722);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TemperatureProvider>();
    final celsius = provider.celsiusValue;
    final result = provider.result;
    final toUnit = provider.toUnit;

    final clampedTemp = celsius.clamp(-40.0, 100.0);
    final fillPercent = (clampedTemp + 40) / 140;
    final tempColor = _tempColor(celsius);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, _) {
        return Transform.scale(
          scale: result != null ? _pulseAnimation.value : 1.0,
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tempColor.withOpacity(0.15),
                  tempColor.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: tempColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Batang thermometer
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Container(
                    height: 100,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        height: 100 * fillPercent,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              tempColor,
                              tempColor.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Teks hasil
                Positioned(
                  left: 60,
                  top: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        result != null
                            ? '${provider.format(result)} ${toUnit.symbol}'
                            : '-- ${toUnit.symbol}',
                        style: TextStyle(
                          color: result != null
                              ? tempColor
                              : Colors.white.withOpacity(0.3),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result != null
                            ? provider.description
                            : 'Masukkan suhu untuk melihat hasil',
                        style: TextStyle(
                          color: Colors.white.withOpacity(
                              result != null ? 0.7 : 0.3),
                          fontSize: result != null ? 13 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
