import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';

class WorkspacePreferencesPage extends StatefulWidget {
  const WorkspacePreferencesPage({super.key});

  @override
  State<WorkspacePreferencesPage> createState() => _WorkspacePreferencesPageState();
}

class _WorkspacePreferencesPageState extends State<WorkspacePreferencesPage> {
  static const Map<String, String> _purposeLabelKeys = {
    'study': 'workspacePurposeStudy',
    'deepFocus': 'workspacePurposeDeepFocus',
    'meetings': 'workspacePurposeMeetings',
    'teamWork': 'workspacePurposeTeamWork',
    'callsInterviews': 'workspacePurposeCallsInterviews',
    'creative': 'workspacePurposeCreative',
  };

  static const Map<String, String> _mattersLabelKeys = {
    'quiet': 'workspaceMatterQuiet',
    'fastWifi': 'workspaceMatterFastWifi',
    'budgetFriendly': 'workspaceMatterBudget',
  };

  final Set<String> _selectedPurposes = <String>{};
  final Set<String> _selectedMatters = <String>{};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFromOnboarding();
  }

  Future<void> _loadFromOnboarding() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    final onboarding = data?['onboarding'];

    if (onboarding is Map<String, dynamic>) {
      final selectedPurposes = (onboarding['selectedPurposes'] as List?)
              ?.map((e) => e.toString())
              .where(_purposeLabelKeys.containsKey)
              .toSet() ??
          <String>{};
      final selectedMatters = (onboarding['selectedMatters'] as List?)
              ?.map((e) => e.toString())
              .where(_mattersLabelKeys.containsKey)
              .toSet() ??
          <String>{};

      setState(() {
        _selectedPurposes
          ..clear()
          ..addAll(selectedPurposes);
        _selectedMatters
          ..clear()
          ..addAll(selectedMatters);
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _save(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'onboarding': {
        'selectedPurposes': _selectedPurposes.toList(growable: false),
        'selectedMatters': _selectedMatters.toList(growable: false),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t('workspaceSavedMessage'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(context.t('workspacePageTitle')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                        context.t('workspacePageDescription'),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.t('workspaceMainPurposeTitle'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._purposeLabelKeys.entries.map(
                        (entry) => CheckboxListTile(
                          value: _selectedPurposes.contains(entry.key),
                          title: Text(context.t(entry.value)),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedPurposes.add(entry.key);
                              } else {
                                _selectedPurposes.remove(entry.key);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        context.t('workspaceWhatMattersTitle'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._mattersLabelKeys.entries.map(
                        (entry) => CheckboxListTile(
                          value: _selectedMatters.contains(entry.key),
                          title: Text(context.t(entry.value)),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedMatters.add(entry.key);
                              } else {
                                _selectedMatters.remove(entry.key);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSaving ? null : () => _save(context),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(context.t('workspaceSaveButton')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
