import 'package:equatable/equatable.dart';

class InsightItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  /// مفاتيح الترجمة — إذا موجودة تُستخدم في الـ UI بدل title/subtitle
  final String? titleKey;
  final String? subtitleKey;

  /// ✅ عندكم في UI: item.imageAsset ?? AppAssets.home
  final String? imageAsset;

  const InsightItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.titleKey,
    this.subtitleKey,
    this.imageAsset,
  });

  @override
  List<Object?> get props => [id, title, subtitle, titleKey, subtitleKey, imageAsset];
}