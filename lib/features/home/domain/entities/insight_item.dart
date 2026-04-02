import 'package:equatable/equatable.dart';

class InsightItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  
  final String? titleKey;
  final String? subtitleKey;

  
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
