import 'package:flutter/material.dart';

class NotificationsListScreen extends StatelessWidget {
  const NotificationsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Updates for you
            const Text(
              'Updates for you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Booking status, reminders, and smart plan tips.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // TODAY
            Text(
              'TODAY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildNotificationItem(
                    icon: Icons.check,
                    iconBg: Colors.grey[200]!,
                    iconColor: Colors.black,
                    title: 'Booking approved',
                    titleColor: const Color(0xFF5B8FB9),
                    subtitle: 'Downtown Hub confirmed your request.',
                    time: '2m',
                    timeColor: const Color(0xFFF5A623),
                    hasInnerCircle: true,
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildNotificationItem(
                    icon: Icons.notifications_outlined,
                    iconBg: Colors.grey[200]!,
                    iconColor: Colors.black,
                    title: 'Reminder before booking',
                    titleColor: const Color(0xFF5B8FB9),
                    subtitle: 'Your session starts in 30 minutes.',
                    time: '45m',
                    timeColor: const Color(0xFFF5A623),
                    iconSize: 30,
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildNotificationItem(
                    icon: Icons.auto_awesome,
                    iconBg: Colors.black,
                    iconColor: const Color(0xFFF5A623),
                    title: 'Offer / plan suggestion',
                    titleColor: const Color(0xFF5B8FB9),
                    subtitle: 'Weekly plan could save you 18% for this space.',
                    time: '1h',
                    timeColor: const Color(0xFFF5A623),
                    showAI: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // EARLIER
            Text(
              'EARLIER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildNotificationItem(
                    icon: Icons.close,
                    iconBg: const Color(0xFF5B8FB9).withOpacity(0.08),
                    iconColor: Colors.red,
                    title: 'Booking rejected',
                    titleColor: Colors.black,
                    subtitle: 'City Study Room couldn\'t confirm your time.',
                    time: 'Yesterday',
                    timeColor: const Color(0xFFF5A623),
                    hasInnerCircle: true,
                    innerCircleColor: Colors.red,
                    innerIconColor: Colors.white,
                  ),
                  Divider(
                    color: Colors.grey[200],
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildNotificationItem(
                    icon: Icons.info_outline,
                    iconBg: const Color(0xFF5B8FB9).withOpacity(0.08),
                    iconColor: const Color(0xFFF5A623),
                    title: 'Tip',
                    titleColor: Colors.black,
                    subtitle: 'You can track all requests in the Bookings tab.',
                    time: '2d',
                    timeColor: const Color(0xFFF5A623),
                    hasInnerCircle: true,
                    innerCircleColor: const Color(0xFFF5A623),
                    innerIconColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required Color titleColor,
    required String subtitle,
    required String time,
    required Color timeColor,
    bool showAI = false,
    bool hasInnerCircle = false,
    double iconSize = 24,
    Color innerCircleColor = Colors.black,
    Color innerIconColor = const Color(0xFFF5A623),
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: showAI
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: iconColor, size: 18),
                      const Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : hasInnerCircle
                ? Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: innerCircleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: innerIconColor, size: 16),
                    ),
                  )
                : Icon(icon, color: iconColor, size: iconSize),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: timeColor,
            ),
          ),
        ],
      ),
    );
  }
}
