import 'package:flutter/material.dart';
import 'booking_details_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'name': 'Blue Owl',
      'date': 'Mon, Oct 14',
      'time': '10:00–14:00',
      'bookingId': 'MH-2481',
      'price': 45,
      'status': 'Upcoming',
      'rating': 4.8,
      'features': 'City Center • Quiet • Fast Wi-Fi',
      'address': '12 King St, Downtown',
    },
    {
      'name': 'Blue Owl',
      'date': 'Mon, Oct 14',
      'time': '10:00–14:00',
      'bookingId': 'MH-2481',
      'price': 45,
      'status': 'Upcoming',
      'rating': 4.8,
      'features': 'City Center • Quiet • Fast Wi-Fi',
      'address': '12 King St, Downtown',
    },
  ];

  final List<Map<String, dynamic>> _pastBookings = [
    {
      'name': 'Blue Owl',
      'date': 'Wed, Sep 11',
      'time': '09:00–12:00',
      'bookingId': 'BO-1904',
      'price': 35,
      'status': 'Completed',
      'rating': 4.8,
      'features': 'City Center • Quiet • Fast Wi-Fi',
      'address': '12 King St, Downtown',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          'Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildSearchRow(),
              const SizedBox(height: 20),
              const Text(
                'Your Upcoming Bookings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ..._upcomingBookings.map((b) => _buildBookingCard(b, isUpcoming: true)),
              const SizedBox(height: 20),
              const Text(
                'Past Bookings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ..._pastBookings.map((b) => _buildBookingCard(b, isUpcoming: false)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.search, color: Colors.grey, size: 20),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF5A623), Color(0xFF5B8FB9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Center(
            child: Text(
              'AI Concierge',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, {required bool isUpcoming}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 100,
                    height: 90,
                    color: const Color(0xFF5B8FB9),
                    child: const Icon(Icons.business, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${booking['date']} • ${booking['time']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Booking ID: ${booking['bookingId']}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₪${booking['price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '/day',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.08),
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking['status'],
                              style: const TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isUpcoming) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingDetailsScreen(booking: booking),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUpcoming
                          ? const Color(0xFF5B8FB9)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(14),
                          bottomRight: isUpcoming ? Radius.zero : const Radius.circular(0),
                        ),
                        side: isUpcoming
                            ? BorderSide.none
                            : BorderSide(color: Colors.grey[300]!),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isUpcoming ? 'View' : 'Rebook',
                      style: TextStyle(
                        color: isUpcoming ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isUpcoming) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingDetailsScreen(booking: booking),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUpcoming
                          ? Colors.white
                          : const Color(0xFF5B8FB9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: const Radius.circular(14),
                          bottomLeft: const Radius.circular(0),
                        ),
                        side: isUpcoming
                            ? BorderSide(color: Colors.grey[300]!)
                            : BorderSide.none,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isUpcoming ? 'Cancel' : 'View',
                      style: TextStyle(
                        color: isUpcoming ? Colors.black : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
            _buildNavItem(Icons.home_outlined, 'Home', false, onTap: () {}),
            _buildNavItem(Icons.menu_book, 'Bookings', true, onTap: () {}),
            _buildNavItem(Icons.person_outline, 'Profile', false, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }),
            _buildNavItem(Icons.settings_outlined, 'Settings', false, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF5B8FB9) : Colors.grey,
            size: 24,
          ),
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
      ),
    );
  }
}
