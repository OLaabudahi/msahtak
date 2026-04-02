import 'package:equatable/equatable.dart';

abstract class UsageEvent extends Equatable {
  const UsageEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل بيانات الاستخدام عند فتح الصفحة
class UsageStarted extends UsageEvent {
  const UsageStarted();
}

/// اختيار باقة من قائمة الباقات
class UsagePlanSelected extends UsageEvent {
  final int index;
  const UsagePlanSelected(this.index);
  @override
  List<Object?> get props => [index];
}

/// تطبيق الباقة المختارة
class UsagePlanApplied extends UsageEvent {
  const UsagePlanApplied();
}
