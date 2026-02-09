import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, child) {
        return Directionality(
          textDirection: localization.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Updates for you',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Booking status, reminders, and smart plan tips.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'TODAY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _buildNotificationItem(
                          icon: Icons.check,
                          iconColor: const Color(0xFFF5A623),
                          iconBgColor: const Color(0xFFD6EAF8),
                          title: 'Booking approved',
                          subtitle: 'Downtown Hub confirmed your request.',
                          time: '2m',
                          isCheckIcon: true,
                        ),
                        const Divider(height: 28),
                        _buildNotificationItem(
                          icon: Icons.notifications_outlined,
                          iconColor: Colors.black,
                          iconBgColor: const Color(0xFFF5F5F5),
                          title: 'Reminder before booking',
                          subtitle: 'Your session starts in 30 minutes.',
                          time: '45m',
                        ),
                        const Divider(height: 28),
                        _buildNotificationItem(
                          icon: Icons.auto_awesome,
                          iconColor: const Color(0xFFF5A623),
                          iconBgColor: Colors.black,
                          title: 'Offer / plan suggestion',
                          subtitle: 'Weekly plan could save you 18% for this space.',
                          time: '1h',
                          isAIIcon: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'EARLIER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _buildNotificationItem(
                          icon: Icons.cancel,
                          iconColor: Colors.red,
                          iconBgColor: const Color(0xFFFFEBEE),
                          title: 'Booking rejected',
                          subtitle: 'City Study Room couldn\'t confirm your time.',
                          time: 'Yesterday',
                        ),
                        const Divider(height: 28),
                        _buildNotificationItem(
                          icon: Icons.info_outline,
                          iconColor: const Color(0xFFF5A623),
                          iconBgColor: const Color(0xFFFFF3E0),
                          title: 'Tip',
                          subtitle: 'You can track all requests in the Bookings tab.',
                          time: '2d',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String time,
    bool isCheckIcon = false,
    bool isAIIcon = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: _buildIconContent(icon, iconColor, isCheckIcon, isAIIcon),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5B8FB9),
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF5A623),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconContent(IconData icon, Color iconColor, bool isCheckIcon, bool isAIIcon) {
    if (isCheckIcon) {
      return Center(
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Icon(
            Icons.check,
            color: iconColor,
            size: 18,
          ),
        ),
      );
    } else if (isAIIcon) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            color: iconColor,
            size: 18,
          ),
          const SizedBox(height: 2),
          const Text(
            'AI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5A623),
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    } else if (icon == Icons.notifications_outlined) {
      return Icon(
        icon,
        color: iconColor,
        size: 26,
      );
    } else {
      return Icon(
        icon,
        color: iconColor,
        size: 22,
      );
    }
  }
}
