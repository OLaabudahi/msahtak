import 'package:equatable/equatable.dart';

abstract class OffersEvent extends Equatable {
  const OffersEvent();
  @override
  List<Object?> get props => [];
}

/// طھط­ظ…ظٹظ„ ط§ظ„ط¹ط±ظˆط¶ ط¹ظ†ط¯ ظپطھط­ ط§ظ„طµظپط­ط©
class OffersStarted extends OffersEvent {
  const OffersStarted();
}

/// طھط­ط¯ظٹط« ظ†طµ ط§ظ„ط¨ط­ط«
class OffersSearchChanged extends OffersEvent {
  final String query;
  const OffersSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// ط§ظ„ط¶ط؛ط· ط¹ظ„ظ‰ ط²ط± Deal ظ„ط¹ط±ط¶ طھظپط§طµظٹظ„ ط§ظ„ط¹ط±ط¶
class OfferDealPressed extends OffersEvent {
  final String offerId;
  const OfferDealPressed(this.offerId);
  @override
  List<Object?> get props => [offerId];
}


