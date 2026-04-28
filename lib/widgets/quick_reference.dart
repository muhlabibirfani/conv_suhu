import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temperature_provider.dart';
import '../models/temp_unit.dart';

/// Daftar referensi suhu umum yang bisa diklik untuk langsung mengisi input.
class QuickReference extends StatelessWidget {
  const QuickReference({super.key, required this.onTap});

  /// Dipanggil dengan nilai [celsius] referensi yang dipilih.
  final ValueChanged<double> onTap;

  static const _references = [
    {'name': 'Air Membeku', 'celsius': 0.0, 'emoji': '🧊'},
    {'name': 'Suhu Ruangan', 'celsius': 22.0, 'emoji': '🏠'},
    {'name': 'Suhu Tubuh', 'celsius': 37.0, 'emoji': '🌡️'},
    {'name': 'Air Mendidih', 'celsius': 100.0, 'emoji': '♨️'},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TemperatureProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFERENSI CEPAT',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ..._references.map((ref) {
          final celsius = ref['celsius'] as double;
          final fromVal = provider.refFromValue(celsius);
          final toVal = provider.refToValue(celsius);

          return GestureDetector(
            onTap: () => onTap(celsius),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Text(ref['emoji'] as String,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ref['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${provider.format(fromVal)}${provider.fromUnit.symbol}',
                    style: TextStyle(
                      color: provider.fromUnit.color.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded,
                      size: 14,
                      color: Colors.white.withOpacity(0.2)),
                  const SizedBox(width: 4),
                  Text(
                    '${provider.format(toVal)}${provider.toUnit.symbol}',
                    style: TextStyle(
                      color: provider.toUnit.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
