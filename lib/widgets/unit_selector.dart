import 'package:flutter/material.dart';
import '../models/temp_unit.dart';

/// Widget pemilih satuan suhu (grid 4 tombol).
/// Sepenuhnya stateless — menerima [selected] dan memanggil [onChanged].
class UnitSelector extends StatelessWidget {
  const UnitSelector({
    super.key,
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final TempUnit selected;
  final ValueChanged<TempUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: TempUnit.values.map((unit) {
            final isSelected = unit == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(unit),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? unit.color.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? unit.color
                          : Colors.white.withOpacity(0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        unit.icon,
                        color: isSelected
                            ? unit.color
                            : Colors.white.withOpacity(0.3),
                        size: 18,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        unit.symbol,
                        style: TextStyle(
                          color: isSelected
                              ? unit.color
                              : Colors.white.withOpacity(0.3),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
