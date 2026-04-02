import 'package:flutter/material.dart';
import '../../../../constants/app_assets.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../domain/entities/insight_item.dart';

class InsightDetailsPage extends StatelessWidget {
  final InsightItem item;
  const InsightDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final content = _contentFor(item.id);
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: AppTextStyles.h1),
              AppSpacing.vMd,
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  item.imageAsset ?? AppAssets.home,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              AppSpacing.vMd,
              Text(item.subtitle, style: AppTextStyles.body),
              AppSpacing.vLg,
              ...content.map((section) => _SectionCard(section: section)),
            ],
          ),
        ),
      ),
    );
  }

  List<_Section> _contentFor(String id) {
    switch (id) {
      case 'ins_4':
        return [
          _Section(title: 'Before the meeting', emoji: 'ًں“‹', items: [
            'Book the meeting room in advance via the app',
            'Confirm attendees and send calendar invites',
            'Prepare your agenda and share it with participants',
            'Test your laptop / presentation setup',
            'Charge all devices fully',
          ]),
          _Section(title: 'Tech & equipment', emoji: 'ًں’»', items: [
            'HDMI / USB-C adapter for screen mirroring',
            'Headset or earphones for calls',
            'Stable Wi-Fi connection confirmed',
            'Backup slides saved offline (USB or local)',
            'Video conferencing app installed & tested',
          ]),
          _Section(title: 'During the meeting', emoji: 'ًںژ¯', items: [
            'Start on time â€” respect everyone\'s schedule',
            'Mute when not speaking',
            'Take notes or assign a note-taker',
            'Keep to the agenda items',
            'Assign action items with owners & deadlines',
          ]),
          _Section(title: 'After the meeting', emoji: 'âœ…', items: [
            'Send meeting minutes within 24 hours',
            'Follow up on action items',
            'Leave the room clean and tidy',
            'Return any borrowed equipment',
          ]),
        ];
      default:
        return [
          _Section(title: 'Tips', emoji: 'ًں’،', items: [item.subtitle]),
        ];
    }
  }
}

class _Section {
  final String title;
  final String emoji;
  final List<String> items;
  const _Section({required this.title, required this.emoji, required this.items});
}

class _SectionCard extends StatelessWidget {
  final _Section section;
  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.settingCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(section.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                section.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6, left: 4, right: 4),
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.btnPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 14, height: 1.4)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
