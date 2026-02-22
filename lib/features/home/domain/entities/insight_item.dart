import 'package:equatable/equatable.dart';

class InsightItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  /// ✅ عندكم في UI: item.imageAsset ?? AppAssets.home
  final String? imageAsset;

  const InsightItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageAsset,
  });

  @override
  List<Object?> get props => [id, title, subtitle, imageAsset];
}