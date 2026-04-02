import 'package:flutter/material.dart';
import '../domain/entities/filter_chip_entity.dart';

class PreferredChipsRow extends StatelessWidget {
  final List<FilterChipEntity> chips;
  final void Function(String chipId) onRemove;

  const PreferredChipsRow({
    super.key,
    required this.chips,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final c = chips[i];
          return InputChip(
            label: Text(c.label),
            onDeleted: () => onRemove(c.id),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: chips.length,
      ),
    );
  }
}


