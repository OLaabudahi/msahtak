import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'best_for_you_screen.dart';
import 'offers_screen.dart';
import 'weekly_plan_screen.dart';
import 'policies_dialog.dart';
import 'bookings_screen.dart';

class ScreensDemo extends StatelessWidget {
  const ScreensDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Msahtak',
          style: TextStyle(
            color: Color(0xFF5B8FB9),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              context,
              'Login',
              Icons.login,
              const LoginScreen(),
            ),
            const SizedBox(height: 16),
            _buildNavButton(
              context,
              'Best For You',
              Icons.recommend,
              const BestForYouScreen(),
            ),
            const SizedBox(height: 16),
            _buildNavButton(
              context,
              'Offers',
              Icons.local_offer,
              const OffersScreen(),
            ),
            const SizedBox(height: 16),
            _buildNavButton(
              context,
              'Weekly Plan',
              Icons.calendar_today,
              const WeeklyPlanScreen(),
            ),
            const SizedBox(height: 16),
            _buildNavButton(
              context,
              'Bookings',
              Icons.menu_book,
              const BookingsScreen(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () => PoliciesDialog.show(context),
                icon: const Icon(Icons.policy, color: Colors.white),
                label: const Text(
                  'Policies',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B8FB9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B8FB9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
