import 'package:flutter/material.dart';

import 'admin_colors.dart';

class AdminSpaceDropdown extends StatelessWidget {
  final String selected;
  final List<String> spaces;
  final bool open;
  final VoidCallback onToggle;
  final ValueChanged<String> onSelect;

  const AdminSpaceDropdown({
    super.key,
    required this.selected,
    required this.spaces,
    required this.open,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Space',
              style: TextStyle(
                fontSize: 14,
                color: AdminColors.black75,
                fontFamily: 'SF Pro Text',
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AdminColors.borderBlack15, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected,
                        style: const TextStyle(fontSize: 16, fontFamily: 'SF Pro Text'),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AdminColors.primaryBlue),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (open)
          Positioned(
            left: 0,
            right: 0,
            top: 16 + 8 + 14 + 8 + 52, 
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AdminColors.borderBlack15, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.10),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(spaces.length, (i) {
                    final s = spaces[i];
                    final isSelected = s == selected;

                    return InkWell(
                      onTap: () => onSelect(s),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromRGBO(86, 130, 175, 0.10) : Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: i < spaces.length - 1 ? const Color.fromRGBO(0, 0, 0, 0.10) : Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(s, style: const TextStyle(fontFamily: 'SF Pro Text')),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
