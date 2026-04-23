import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/help_content_entity.dart';
import '../../domain/repos/help_content_repo.dart';

class HelpContentRepoFirebase implements HelpContentRepo {
  static const _faqCacheKey = 'help_faq_cache_v1';
  static const _faqCacheAtKey = 'help_faq_cache_at_v1';
  static const _aboutCacheKey = 'help_about_cache_v1';
  static const _aboutCacheAtKey = 'help_about_cache_at_v1';
  static const _cacheTtl = Duration(hours: 24);

  final FirebaseFirestore _firestore;

  HelpContentRepoFirebase({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<FaqItemEntity>> getFaqItems() async {
    final cached = await _readFaqCache();
    if (cached != null && cached.isNotEmpty) return cached;

    try {
      final doc = await _firestore.collection('app_content').doc('faq').get();
      final data = doc.data();
      final rawItems = (data?['items'] as List?)?.whereType<Map>().toList() ?? const [];

      final items = rawItems.map((m) {
        final map = Map<String, dynamic>.from(m);
        return FaqItemEntity(
          questionAr: (map['question_ar'] ?? '').toString(),
          questionEn: (map['question_en'] ?? '').toString(),
          answerAr: (map['answer_ar'] ?? '').toString(),
          answerEn: (map['answer_en'] ?? '').toString(),
          order: (map['order'] as num?)?.toInt() ?? 0,
        );
      }).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      if (items.isNotEmpty) {
        await _saveFaqCache(items);
      }
      return items;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<AboutContentEntity?> getAboutContent() async {
    final cached = await _readAboutCache();
    if (cached != null) return cached;

    try {
      final doc = await _firestore.collection('app_content').doc('about_mashtak').get();
      final data = doc.data();
      if (data == null || data.isEmpty) return null;

      final entity = AboutContentEntity(
        appInfoAr: (data['app_info_ar'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        appInfoEn: (data['app_info_en'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        policiesAr: (data['policies_ar'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        policiesEn: (data['policies_en'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
      await _saveAboutCache(entity);
      return entity;
    } catch (_) {
      return null;
    }
  }

  Future<List<FaqItemEntity>?> _readFaqCache() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_faqCacheKey);
    final at = sp.getInt(_faqCacheAtKey);
    if (raw == null || at == null) return null;
    if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(at)) > _cacheTtl) {
      return null;
    }
    try {
      final list = (jsonDecode(raw) as List).whereType<Map>().map((m) {
        final map = Map<String, dynamic>.from(m);
        return FaqItemEntity(
          questionAr: (map['question_ar'] ?? '').toString(),
          questionEn: (map['question_en'] ?? '').toString(),
          answerAr: (map['answer_ar'] ?? '').toString(),
          answerEn: (map['answer_en'] ?? '').toString(),
          order: (map['order'] as num?)?.toInt() ?? 0,
        );
      }).toList();
      return list;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveFaqCache(List<FaqItemEntity> items) async {
    final sp = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      items
          .map((e) => {
                'question_ar': e.questionAr,
                'question_en': e.questionEn,
                'answer_ar': e.answerAr,
                'answer_en': e.answerEn,
                'order': e.order,
              })
          .toList(),
    );
    await sp.setString(_faqCacheKey, encoded);
    await sp.setInt(_faqCacheAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<AboutContentEntity?> _readAboutCache() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_aboutCacheKey);
    final at = sp.getInt(_aboutCacheAtKey);
    if (raw == null || at == null) return null;
    if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(at)) > _cacheTtl) {
      return null;
    }
    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      return AboutContentEntity(
        appInfoAr: (map['app_info_ar'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        appInfoEn: (map['app_info_en'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        policiesAr: (map['policies_ar'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        policiesEn: (map['policies_en'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveAboutCache(AboutContentEntity content) async {
    final sp = await SharedPreferences.getInstance();
    final encoded = jsonEncode({
      'app_info_ar': content.appInfoAr,
      'app_info_en': content.appInfoEn,
      'policies_ar': content.policiesAr,
      'policies_en': content.policiesEn,
    });
    await sp.setString(_aboutCacheKey, encoded);
    await sp.setInt(_aboutCacheAtKey, DateTime.now().millisecondsSinceEpoch);
  }
}
