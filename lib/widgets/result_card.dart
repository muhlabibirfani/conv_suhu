import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/temperature_provider.dart';
import '../models/temp_unit.dart';

/// Kartu hasil konversi + mini konversi ke semua satuan lain.
class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TemperatureProvider>();
    final result = provider.result;

    if (result == null) return const SizedBox.shrink();

    final toUnit = provider.toUnit;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              toUnit.color.withOpacity(0.15),
              toUnit.color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: toUnit.color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Icon satuan tujuan
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: toUnit.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(toUnit.icon, color: toUnit.color, size: 24),
            ),
            const SizedBox(width: 16),
            // Hasil utama
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Konversi',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.format(result)} ${toUnit.symbol}',
                    style: TextStyle(
                      color: toUnit.color,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    toUnit.label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Mini konversi ke satuan lain
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: TempUnit.values
                  .where((u) => u != toUnit)
                  .map((u) {
                final val = provider.allResults[u] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${provider.format(val)}${u.symbol}',
                    style: TextStyle(
                      color: u.color.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
