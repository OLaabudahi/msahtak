import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class TwoButtonsBar extends StatelessWidget {
  const TwoButtonsBar({
    required this.leftText,
    required this.leftFilled,
    required this.onLeft,
    required this.rightText,
    required this.rightFilled,
    required this.onRight,
  });

  final String leftText;
  final bool leftFilled;
  final VoidCallback onLeft;

  final String rightText;
  final bool rightFilled;
  final VoidCallback onRight;

  static const _blue = AppColors.btnSecondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onLeft,
              child: Container(
                color: leftFilled ? _blue : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  leftText,
                  style: TextStyle(
                    color: leftFilled ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, color: AppColors.borderLight),
          Expanded(
            child: InkWell(
              onTap: onRight,
              child: Container(
                color: rightFilled ? _blue : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  rightText,
                  style: TextStyle(
                    color: rightFilled ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


