import 'package:flutter/material.dart';

class UsageBars extends StatelessWidget {
  final List<Map<String, dynamic>> items; // {label, percent}

  final Color labelColor;
  final Color percentColor;
  final Color trackColor;
  final Color fillColor;

  const UsageBars({
    super.key,
    required this.items,
    required this.labelColor,
    required this.percentColor,
    required this.trackColor,
    required this.fillColor,
  });

  /// ✅ دالة: Progress bars لقسم "Who usually uses this space"
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((e) {
        final label = e['label'] as String;
        final percent = (e['percent'] as int).clamp(0, 100);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: labelColor),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Stack(
                    children: [
                      Container(height: 8, color: trackColor),
                      FractionallySizedBox(
                        widthFactor: percent / 100,
                        child: Container(height: 8, color: fillColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 38,
                child: Text(
                  '$percent%',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: percentColor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
