import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class UsageBars extends StatelessWidget {
  final List<Map<String, dynamic>> items; // {label, percent}

  const UsageBars({super.key, required this.items});

  /// âœ… ط¯ط§ظ„ط©: Progress bars ط¨ظ†ظپط³ ط´ظƒظ„ ط§ظ„طھطµظ…ظٹظ… (gradient + track ط±ظ…ط§ط¯ظٹ)
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
                  color: Color(0xFFE9EFF6), // âœ… ط§ظ„ط±ظ…ط§ط¯ظٹ ط§ظ„ظپط§طھط­ ظ…ط«ظ„ ط§ظ„طµظˆط±ط©
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: percent / 100,
                      child: Container(
                        height: 10,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2B6CB0), // âœ… ط£ط²ط±ظ‚
                              AppColors.amber, // âœ… ط£طµظپط±
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


