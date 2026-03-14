import 'package:equatable/equatable.dart';
import '../domain/entities/offer_duration_unit.dart';
import '../domain/entities/offer_entity.dart';
import '../domain/entities/offer_type.dart';
import '../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';

enum OffersStatus { initial, loading, ready, failure, creating }

class OffersCreateForm extends Equatable {
  final OfferType type;

  final String title;
  final String validUntil;
  final bool enabled;

  final String durationValue;
  final OfferDurationUnit durationUnit;

  final String discountPercent;

  final String fixedPriceValue;
  final PriceUnit fixedPriceUnit;

  final int packageMonths;
  final String packageDiscountPercent;
  final String fixedMonthlyPrice;

  final String bonusText;

  final String? titleError;
  final String? validUntilError;
  final String? discountError;
  final String? fixedPriceError;
  final String? packageError;
  final String? bonusError;
  final String? durationError;

  const OffersCreateForm({
    required this.type,
    required this.title,
    required this.validUntil,
    required this.enabled,
    required this.durationValue,
    required this.durationUnit,
    required this.discountPercent,
    required this.fixedPriceValue,
    required this.fixedPriceUnit,
    required this.packageMonths,
    required this.packageDiscountPercent,
    required this.fixedMonthlyPrice,
    required this.bonusText,
    required this.titleError,
    required this.validUntilError,
    required this.discountError,
    required this.fixedPriceError,
    required this.packageError,
    required this.bonusError,
    required this.durationError,
  });

  factory OffersCreateForm.initial() => const OffersCreateForm(
    type: OfferType.fixedPriceOverride,
    title: '',
    validUntil: '',
    enabled: true,
    durationValue: '',
    durationUnit: OfferDurationUnit.days,
    discountPercent: '',
    fixedPriceValue: '',
    fixedPriceUnit: PriceUnit.day,
    packageMonths: 3,
    packageDiscountPercent: '',
    fixedMonthlyPrice: '',
    bonusText: '',
    titleError: null,
    validUntilError: null,
    discountError: null,
    fixedPriceError: null,
    packageError: null,
    bonusError: null,
    durationError: null,
  );

  OffersCreateForm copyWith({
    OfferType? type,
    String? title,
    String? validUntil,
    bool? enabled,
    String? durationValue,
    OfferDurationUnit? durationUnit,
    String? discountPercent,
    String? fixedPriceValue,
    PriceUnit? fixedPriceUnit,
    int? packageMonths,
    String? packageDiscountPercent,
    String? fixedMonthlyPrice,
    String? bonusText,
    String? titleError,
    String? validUntilError,
    String? discountError,
    String? fixedPriceError,
    String? packageError,
    String? bonusError,
    String? durationError,
    bool clearErrors = false,
  }) {
    return OffersCreateForm(
      type: type ?? this.type,
      title: title ?? this.title,
      validUntil: validUntil ?? this.validUntil,
      enabled: enabled ?? this.enabled,
      durationValue: durationValue ?? this.durationValue,
      durationUnit: durationUnit ?? this.durationUnit,
      discountPercent: discountPercent ?? this.discountPercent,
      fixedPriceValue: fixedPriceValue ?? this.fixedPriceValue,
      fixedPriceUnit: fixedPriceUnit ?? this.fixedPriceUnit,
      packageMonths: packageMonths ?? this.packageMonths,
      packageDiscountPercent: packageDiscountPercent ?? this.packageDiscountPercent,
      fixedMonthlyPrice: fixedMonthlyPrice ?? this.fixedMonthlyPrice,
      bonusText: bonusText ?? this.bonusText,
      titleError: clearErrors ? null : (titleError ?? this.titleError),
      validUntilError: clearErrors ? null : (validUntilError ?? this.validUntilError),
      discountError: clearErrors ? null : (discountError ?? this.discountError),
      fixedPriceError: clearErrors ? null : (fixedPriceError ?? this.fixedPriceError),
      packageError: clearErrors ? null : (packageError ?? this.packageError),
      bonusError: clearErrors ? null : (bonusError ?? this.bonusError),
      durationError: clearErrors ? null : (durationError ?? this.durationError),
    );
  }

  @override
  List<Object?> get props => [
    type,
    title,
    validUntil,
    enabled,
    durationValue,
    durationUnit,
    discountPercent,
    fixedPriceValue,
    fixedPriceUnit,
    packageMonths,
    packageDiscountPercent,
    fixedMonthlyPrice,
    bonusText,
    titleError,
    validUntilError,
    discountError,
    fixedPriceError,
    packageError,
    bonusError,
    durationError,
  ];
}

class OffersState extends Equatable {
  final OffersStatus status;
  final List<OfferEntity> offers;
  final bool createOpen;
  final OffersCreateForm form;
  final String? error;

  const OffersState({
    required this.status,
    required this.offers,
    required this.createOpen,
    required this.form,
    required this.error,
  });

  factory OffersState.initial() => OffersState(
    status: OffersStatus.initial,
    offers: const [],
    createOpen: false,
    form: OffersCreateForm.initial(),
    error: null,
  );

  OffersState copyWith({
    OffersStatus? status,
    List<OfferEntity>? offers,
    bool? createOpen,
    OffersCreateForm? form,
    String? error,
  }) {
    return OffersState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      createOpen: createOpen ?? this.createOpen,
      form: form ?? this.form,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, offers, createOpen, form, error];
}