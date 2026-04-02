import 'package:flutter/material.dart';

import '../core/i18n/app_i18n.dart';

class PoliciesDialog extends StatelessWidget {
  final String hubName;

  const PoliciesDialog({Key? key, this.hubName = 'Downtown Hub'})
    : super(key: key);

  static void show(BuildContext context, {String hubName = 'Downtown Hub'}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PoliciesDialog(hubName: hubName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      hubName+context.t('policies'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please read before booking. Policies may vary.',
                    style: TextStyle(fontSize: 12, color: Colors.red[400]),
                  ),
                  const SizedBox(height: 20),
                  _buildSection('Noise & Calls', [
                    'Quiet zones are available.',
                    'Calls are allowed in designated areas only.',
                    'For online meetings, please use headphones.',
                    'Keep your voice low in shared areas.',
                  ]),
                  _buildSection('Food & Drinks', [
                    'Drinks are allowed at desks.',
                    'Food is allowed in the dining area only.',
                    'Please clean your table after eating.',
                    'Strong-smell food is not recommended.',
                  ]),
                  _buildSection('Conduct', [
                    'Respect other guests and staff.',
                    'Keep your workspace clean after use.',
                    'Do not move furniture without permission.',
                    'The space may refuse service for disruptive behavior.',
                  ]),
                  _buildSection('Equipment & Space Use', [
                    'Use equipment responsibly.',
                    'Report any damage immediately.',
                    'Return shared items after use.',
                    'Do not unplug others\' devices.',
                  ]),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                '* $item',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


