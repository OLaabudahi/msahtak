import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class OffersSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const OffersSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child:
                Icon(Icons.search, color: Colors.grey, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search offers',
                hintStyle:
                    TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 12),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 2),
            child: IconButton(
              icon: Icon(Icons.filter_list,
                  color: AppColors.textMuted, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}


