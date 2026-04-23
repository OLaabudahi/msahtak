import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../data/repos/help_content_repo_firebase.dart';
import '../domain/entities/help_content_entity.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final Future<List<FaqItemEntity>> _faqFuture;
  final HelpContentRepoFirebase _contentRepo = HelpContentRepoFirebase();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _faqFuture = _contentRepo.getFaqItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t('helpSupportSubmitted'))),
    );
    _nameController.clear();
    _phoneController.clear();
    _reasonController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(context.t('helpSupportPageTitle')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.t('helpSupportFaqTab')),
            Tab(text: context.t('helpSupportContactTab')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                child: FutureBuilder<List<FaqItemEntity>>(
                  future: _faqFuture,
                  builder: (context, snapshot) {
                    final remoteFaq = snapshot.data ?? const <FaqItemEntity>[];
                    final isArabic = context.isArabic;
                    final fallbackFaq = _fallbackFaq(context);
                    final faqs = remoteFaq.isNotEmpty
                        ? remoteFaq
                            .map(
                              (item) => _FaqVm(
                                question: isArabic ? item.questionAr : item.questionEn,
                                answer: isArabic ? item.answerAr : item.answerEn,
                              ),
                            )
                            .toList()
                        : fallbackFaq;

                    return Column(
                      children: faqs
                          .map((item) => _FaqTile(question: item.question, answer: item.answer))
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('helpSupportEmail'),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.t('helpSupportNameLabel'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: context.t('helpSupportPhoneLabel'),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: context.t('helpSupportReasonLabel'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: context.t('helpSupportDescriptionLabel'),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _submit(context),
                      child: Text(context.t('helpSupportSendButton')),
                    ),
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

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black12,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(question),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}

class _FaqVm {
  final String question;
  final String answer;
  const _FaqVm({required this.question, required this.answer});
}

extension on _HelpSupportPageState {
  List<_FaqVm> _fallbackFaq(BuildContext context) {
    return List<_FaqVm>.generate(14, (i) {
      final n = i + 1;
      return _FaqVm(
        question: context.t('faqQuestion$n'),
        answer: context.t('faqAnswer$n'),
      );
    });
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

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
