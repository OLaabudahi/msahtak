import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/msahtak_logo.png',
              width: 280,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'مساحتك\nMsahtak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B8FB9),
                    height: 1.3,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Color(0xFFF5A623)),
          ],
        ),
      ),
    );
  }
}
