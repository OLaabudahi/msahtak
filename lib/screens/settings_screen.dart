import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'PREFERENCES',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            _buildSection([
              _buildItem(
                context,
                'Workspace preferences',
                'Study, work, meetings',
              ),
              _buildItem(
                context,
                'Location',
                'Nearby & map search',
              ),
              _buildItem(
                context,
                'Notifications',
                'Booking & offers',
                isLast: true,
              ),
            ]),
            const SizedBox(height: 24),
            const Text(
              'SUPPORT',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            _buildSection([
              _buildItem(
                context,
                'Help & support',
                'FAQs, contact us',
              ),
              _buildItem(
                context,
                'About Mashtak',
                'Version, terms, privacy',
                isLast: true,
              ),
            ]),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSection(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF5B8FB9).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: items),
    );
  }

  Widget _buildItem(
    BuildContext context,
    String title,
    String subtitle, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: const Color(0xFF5B8FB9), size: 22),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: const Color(0xFF5B8FB9).withOpacity(0.15),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false),
            _buildNavItem(Icons.menu_book, 'Bookings', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
            _buildNavItem(Icons.settings, 'Settings', true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF5B8FB9) : Colors.grey, size: 24),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF5B8FB9) : Colors.grey,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
