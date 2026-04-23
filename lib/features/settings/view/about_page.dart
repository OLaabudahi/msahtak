import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../data/repos/help_content_repo_firebase.dart';
import '../domain/entities/help_content_entity.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final Future<AboutContentEntity?> _aboutFuture;
  final HelpContentRepoFirebase _contentRepo = HelpContentRepoFirebase();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _aboutFuture = _contentRepo.getAboutContent();
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
          FutureBuilder<AboutContentEntity?>(
            future: _aboutFuture,
            builder: (context, snapshot) {
              final isArabic = context.isArabic;
              final remote = snapshot.data;
              final lines = remote == null
                  ? _fallbackAppInfo(context)
                  : (isArabic ? remote.appInfoAr : remote.appInfoEn);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _AboutCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: lines.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(e),
                      )).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
          FutureBuilder<AboutContentEntity?>(
            future: _aboutFuture,
            builder: (context, snapshot) {
              final isArabic = context.isArabic;
              final remote = snapshot.data;
              final lines = remote == null
                  ? _fallbackPolicies(context)
                  : (isArabic ? remote.policiesAr : remote.policiesEn);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _AboutCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: lines.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(e),
                      )).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<String> _fallbackAppInfo(BuildContext context) {
    return [
      context.t('aboutAppHeading'),
      context.t('aboutAppDescription'),
      context.t('aboutProvidesTitle'),
      context.t('aboutFeatureSearch'),
      context.t('aboutFeatureBookingPlans'),
      context.t('aboutFeatureRatings'),
      context.t('aboutFeatureFavorites'),
      context.t('aboutFeatureInvoices'),
      context.t('aboutFeatureAi'),
      context.t('aboutVersionText'),
      context.t('aboutToolsTitle'),
      context.t('aboutToolFlutter'),
      context.t('aboutToolFirebase'),
      context.t('aboutToolFirestore'),
      context.t('aboutToolMapLocation'),
      context.t('aboutToolPrefs'),
    ];
  }

  List<String> _fallbackPolicies(BuildContext context) {
    return [
      context.t('aboutPoliciesTitle'),
      context.t('aboutTermsSectionTitle'),
      context.t('aboutTermsItem1'),
      context.t('aboutTermsItem2'),
      context.t('aboutTermsItem3'),
      context.t('aboutTermsItem4'),
      context.t('aboutTermsItem5'),
      context.t('aboutTermsItem6'),
      context.t('aboutUsageSectionTitle'),
      context.t('aboutUsageItem1'),
      context.t('aboutUsageItem2'),
      context.t('aboutUsageItem3'),
      context.t('aboutUsageItem4'),
      context.t('aboutPrivacySectionTitle'),
      context.t('aboutPrivacyItem1'),
      context.t('aboutPrivacyItem2'),
      context.t('aboutPrivacyItem3'),
      context.t('aboutPrivacyItem4'),
      context.t('aboutPrivacyItem5'),
    ];
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
