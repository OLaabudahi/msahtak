import 'package:flutter/material.dart';

class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFD6EAF8),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.g_mobiledata, size: 34, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 40),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFB3E5FC),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.apple, size: 28, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
