import 'package:flutter/material.dart';

class UsageBars extends StatelessWidget {
  final List<Map<String, dynamic>> items; // {label, percent}

  const UsageBars({super.key, required this.items});

  /// ✅ دالة: Progress bars بنفس شكل التصميم (gradient + track رمادي)
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((e) {
        final label = e['label'] as String;
        final percent = (e['percent'] as int).clamp(0, 100);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Track + Fill
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 10,
                  color: const Color(0xFFE9EFF6), // ✅ الرمادي الفاتح مثل الصورة
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: percent / 100,
                      child: Container(
                        height: 10,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2B6CB0), // ✅ أزرق
                              Color(0xFFF8B324), // ✅ أصفر
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
