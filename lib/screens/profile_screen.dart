import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _paymentExpanded = false;

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
          'Profile',
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
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildMenuSection(),
            const SizedBox(height: 20),
            _buildLogOut(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5B8FB9).withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF5A623), width: 3),
                      color: Colors.grey[300],
                    ),
                    child: const ClipOval(
                      child: Icon(Icons.person, size: 48, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5A623),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Bookings', '12'),
                    _buildStat('Reviews', '5'),
                    _buildStat('Saved', '7'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Asma yazn',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text('asma_yaza@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 1),
          Text('+970 595 959 595', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF5A623),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuItem('P', 'Personal Info', onTap: () {}),
          _buildDivider(),
          _buildMenuItem('B', 'Your usage', onTap: () {}),
          _buildDivider(),
          _buildMenuItem('\$', 'Payments & Receipts', onTap: () {}),
          _buildDivider(),
          _buildPaymentDetails(),
          _buildDivider(),
          _buildMenuItem('★', 'Reviews & Ratings', isStarIcon: true, onTap: () {}),
          _buildDivider(),
          _buildMenuItem('♥', 'Saved Spaces', isHeartIcon: true, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String iconLabel,
    String title, {
    bool isStarIcon = false,
    bool isHeartIcon = false,
    required VoidCallback onTap,
  }) {
    IconData iconData;
    if (isStarIcon) {
      iconData = Icons.star;
    } else if (isHeartIcon) {
      iconData = Icons.favorite;
    } else {
      iconData = Icons.circle;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF5A623),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: (isStarIcon || isHeartIcon)
                    ? Icon(iconData, color: Colors.black, size: 18)
                    : Text(
                        iconLabel,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[500], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _paymentExpanded = !_paymentExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5A623),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '\$D',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  _paymentExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  color: Colors.grey[500],
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (_paymentExpanded)
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildPaymentRow('Visa', '*** 123'),
                Divider(height: 1, color: Colors.grey[200]),
                _buildPaymentRow('Expires date', '08/25'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text(value, style: const TextStyle(fontSize: 13, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300], indent: 16, endIndent: 16);
  }

  Widget _buildLogOut(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: Transform.scale(
              scaleX: -1,
              child: Icon(Icons.login, color: Colors.black, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
            _buildNavItem(Icons.person, 'Profile', true),
            _buildNavItem(Icons.settings_outlined, 'Settings', false),
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
