import 'package:equatable/equatable.dart';

abstract class BestForYouEvent extends Equatable {
  const BestForYouEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل البيانات عند فتح الصفحة بالهدف الافتراضي
class BestForYouStarted extends BestForYouEvent {
  const BestForYouStarted();
}

/// تغيير الهدف المختار (Study / Work / Meeting / Relax)
class BestForYouGoalChanged extends BestForYouEvent {
  final String goal;
  const BestForYouGoalChanged(this.goal);
  @override
  List<Object?> get props => [goal];
}

/// الضغط على زر "Continue to Booking"
class BestForYouContinuePressed extends BestForYouEvent {
  const BestForYouContinuePressed();
}
