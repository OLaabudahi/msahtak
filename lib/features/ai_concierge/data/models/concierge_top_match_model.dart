import 'package:equatable/equatable.dart';

class ConciergeTopMatchModel extends Equatable {
  final String spaceId;
  final String title;
  final String whyLine;
  final String planLine;
  final String priceLine;

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