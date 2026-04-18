import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(context.t('aboutPageTitle')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.t('aboutTabAppInfo')),
            Tab(text: context.t('aboutTabPolicies')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AboutCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('aboutAppHeading'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(context.t('aboutAppDescription')),
                    const SizedBox(height: 14),
                    Text(context.t('aboutProvidesTitle')),
                    const SizedBox(height: 8),
                    Text(context.t('aboutFeatureSearch')),
                    Text(context.t('aboutFeatureBookingPlans')),
                    Text(context.t('aboutFeatureRatings')),
                    Text(context.t('aboutFeatureFavorites')),
                    Text(context.t('aboutFeatureInvoices')),
                    Text(context.t('aboutFeatureAi')),
                    const SizedBox(height: 16),
                    Text(
                      context.t('aboutVersionText'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.t('aboutToolsTitle'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(context.t('aboutToolFlutter')),
                    Text(context.t('aboutToolFirebase')),
                    Text(context.t('aboutToolFirestore')),
                    Text(context.t('aboutToolMapLocation')),
                    Text(context.t('aboutToolPrefs')),
                  ],
                ),
              ),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AboutCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('aboutPoliciesTitle'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.t('aboutTermsSectionTitle'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(context.t('aboutTermsItem1')),
                    Text(context.t('aboutTermsItem2')),
                    Text(context.t('aboutTermsItem3')),
                    Text(context.t('aboutTermsItem4')),
                    Text(context.t('aboutTermsItem5')),
                    Text(context.t('aboutTermsItem6')),
                    const SizedBox(height: 14),
                    Text(
                      context.t('aboutUsageSectionTitle'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(context.t('aboutUsageItem1')),
                    Text(context.t('aboutUsageItem2')),
                    Text(context.t('aboutUsageItem3')),
                    Text(context.t('aboutUsageItem4')),
                    const SizedBox(height: 14),
                    Text(
                      context.t('aboutPrivacySectionTitle'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(context.t('aboutPrivacyItem1')),
                    Text(context.t('aboutPrivacyItem2')),
                    Text(context.t('aboutPrivacyItem3')),
                    Text(context.t('aboutPrivacyItem4')),
                    Text(context.t('aboutPrivacyItem5')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final Widget child;
  const _AboutCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
