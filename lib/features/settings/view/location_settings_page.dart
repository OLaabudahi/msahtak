import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import 'package:geolocator/geolocator.dart';

import '../../map/view/map_page.dart';

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  bool _isLoading = false;
  String _statusKey = 'locationStatusNotSelected';
  String _statusValue = '';

  Future<void> _pickMainLocation() async {
    setState(() => _isLoading = true);

    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      _setDone('locationStatusServiceDisabled');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _setDone('locationStatusPermissionDenied');
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('preferences')
          .set({
        'mainLocation': {
          'lat': position.latitude,
          'lng': position.longitude,
          'savedAt': FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));
    }

    _setDone(
      'locationStatusSaved',
      '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
    );
  }

  void _setDone(String statusKey, [String statusValue = '']) {
    if (!mounted) return;
    setState(() {
      _statusKey = statusKey;
      _statusValue = statusValue;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _statusValue.isEmpty
        ? context.t(_statusKey)
        : context.t(_statusKey).replaceFirst('{coords}', _statusValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(context.t('locationPageTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t('locationPageDescription'),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isLoading ? null : _pickMainLocation,
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: Text(context.t('locationAddMainButton')),
                ),
                const SizedBox(height: 14),
                Text(statusText, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  context.t('locationNearbyMapTitle'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(context.t('locationNearbyMapDescription')),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MapPage.withBloc()),
                    );
                  },
                  icon: const Icon(Icons.map_outlined),
                  label: Text(context.t('locationOpenNearbyMapButton')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
