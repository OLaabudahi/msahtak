import 'package:equatable/equatable.dart';

class ConciergeTopMatchModel extends Equatable {
  final String spaceId;
  final String title; // "Top Match: Space A"
  final String whyLine; // "Why: very quiet..."
  final String planLine; // "Plan suggestion: ..."
  final String priceLine; // "Daily ... • Weekly ..."

  /// asset الآن - API ready
  final String imageAsset;

  const ConciergeTopMatchModel({
    required this.spaceId,
    required this.title,
    required this.whyLine,
    required this.planLine,
    required this.priceLine,
    required this.imageAsset,
  });

  @override
  List<Object?> get props => [spaceId, title, whyLine, planLine, priceLine, imageAsset];
}