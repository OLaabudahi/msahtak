import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/offer_duration_unit.dart';
import '../domain/entities/offer_entity.dart';
import '../domain/entities/offer_type.dart';
import '../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';
import '../domain/usecases/create_offer_usecase.dart';
import '../domain/usecases/get_offers_usecase.dart';
import '../domain/usecases/toggle_offer_usecase.dart';

import 'offers_management_event.dart';
import 'offers_management_state.dart';

class OffersManagementBloc extends Bloc<OffersManagementEvent, OffersManagementState> {
  final GetOffersUseCase getOffers;
  final ToggleOfferUseCase toggleOffer;
  final CreateOfferUseCase createOffer;

  OffersManagementBloc({
    required this.getOffers,
    required this.toggleOffer,
    required this.createOffer,
  }) : super(OffersManagementState.initial()) {
    on<OffersManagementStarted>(_onStarted);
    on<OffersManagementTogglePressed>(_onToggle);
    on<OffersManagementCreateOpened>(_onOpen);
    on<OffersManagementCreateClosed>(_onClose);
    on<OffersManagementCreateFieldChanged>(_onField);
    on<OffersManagementCreateTypeChanged>(_onType);
    on<OffersManagementCreateDurationUnitChanged>(_onDurUnit);
    on<OffersManagementCreateFixedUnitChanged>(_onFixedUnit);
    on<OffersManagementCreatePackageMonthsChanged>(_onPkgMonths);
    on<OffersManagementCreateSubmitted>(_onSubmit);
  }

  Future<void> _onStarted(OffersManagementStarted e, Emitter<OffersManagementState> emit) async {
    emit(state.copyWith(status: OffersManagementStatus.loading, error: null));
    try {
      final list = await getOffers();
      emit(state.copyWith(status: OffersManagementStatus.ready, offers: list));
    } catch (err) {
      emit(state.copyWith(status: OffersManagementStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onToggle(OffersManagementTogglePressed e, Emitter<OffersManagementState> emit) async {
    await toggleOffer(offerId: e.offerId, enabled: e.enabled);
    add(const OffersManagementStarted());
  }

  void _onOpen(OffersManagementCreateOpened e, Emitter<OffersManagementState> emit) {
    emit(state.copyWith(createOpen: true, form: OffersCreateForm.initial().copyWith(clearErrors: true)));
  }

  void _onClose(OffersManagementCreateClosed e, Emitter<OffersManagementState> emit) {
    emit(state.copyWith(createOpen: false, form: OffersCreateForm.initial()));
  }

  void _onField(OffersManagementCreateFieldChanged e, Emitter<OffersManagementState> emit) {
    final f = state.form;
    OffersCreateForm next = f;
    switch (e.field) {
      case 'title':
        next = f.copyWith(title: e.value, titleError: null);
        break;
      case 'validUntil':
        next = f.copyWith(validUntil: e.value, validUntilError: null);
        break;
      case 'durationValue':
        next = f.copyWith(durationValue: e.value, durationError: null);
        break;
      case 'discountPercent':
        next = f.copyWith(discountPercent: e.value, discountError: null);
        break;
      case 'fixedPriceValue':
        next = f.copyWith(fixedPriceValue: e.value, fixedPriceError: null);
        break;
      case 'packageDiscountPercent':
        next = f.copyWith(packageDiscountPercent: e.value, packageError: null);
        break;
      case 'fixedMonthlyPrice':
        next = f.copyWith(fixedMonthlyPrice: e.value, packageError: null);
        break;
      case 'bonusText':
        next = f.copyWith(bonusText: e.value, bonusError: null);
        break;
    }
    emit(state.copyWith(form: next));
  }

  void _onType(OffersManagementCreateTypeChanged e, Emitter<OffersManagementState> emit) {
    emit(state.copyWith(form: state.form.copyWith(type: e.type, clearErrors: true)));
  }

  void _onDurUnit(OffersManagementCreateDurationUnitChanged e, Emitter<OffersManagementState> emit) {
    emit(state.copyWith(form: state.form.copyWith(durationUnit: e.unit)));
  }

  void _onFixedUnit(OffersManagementCreateFixedUnitChanged e, Emitter<OffersManagementState> emit) {
    emit(state.copyWith(form: state.form.copyWith(fixedPriceUnit: e.unit)));
  }

  void _onPkgMonths(OffersManagementCreatePackageMonthsChanged e, Emitter<OffersManagementState> emit) {
    emit(state.copyWith(form: state.form.copyWith(packageMonths: e.months, packageError: null)));
  }

  Future<void> _onSubmit(OffersManagementCreateSubmitted e, Emitter<OffersManagementState> emit) async {
    final f = state.form;
    final errors = _validate(f);
    if (errors != null) {
      emit(state.copyWith(form: f.copyWith(
        titleError: errors['title'],
        validUntilError: errors['validUntil'],
        durationError: errors['duration'],
        discountError: errors['discount'],
        fixedPriceError: errors['fixedPrice'],
        packageError: errors['package'],
        bonusError: errors['bonus'],
      )));
      return;
    }

    emit(state.copyWith(status: OffersManagementStatus.creating));

    final id = 'o_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}';
    final offer = _buildOffer(id, f);

    try {
      await createOffer(offer: offer);
      emit(state.copyWith(createOpen: false, form: OffersCreateForm.initial(), status: OffersManagementStatus.ready));
      add(const OffersManagementStarted());
    } catch (err) {
      emit(state.copyWith(status: OffersManagementStatus.failure, error: err.toString()));
    }
  }

  Map<String, String>? _validate(OffersCreateForm f) {
    final out = <String, String>{};

    if (f.title.trim().isEmpty) out['title'] = 'Title is required';
    if (f.validUntil.trim().isEmpty) out['validUntil'] = 'Valid until is required';

    // duration is optional BUT if user types value, must be >0
    if (f.durationValue.trim().isNotEmpty) {
      final dv = int.tryParse(f.durationValue.trim());
      if (dv == null || dv <= 0) out['duration'] = 'Invalid duration';
    }

    switch (f.type) {
      case OfferType.discountPercent:
        final p = double.tryParse(f.discountPercent.replaceAll(',', '.').trim());
        if (p == null || p <= 0 || p > 100) out['discount'] = 'Discount must be 1..100';
        break;

      case OfferType.fixedPriceOverride:
        final v = double.tryParse(f.fixedPriceValue.replaceAll(',', '.').trim());
        if (v == null || v <= 0) out['fixedPrice'] = 'Fixed price must be > 0';
        break;

      case OfferType.packageMonths:
        // require either packageDiscountPercent OR fixedMonthlyPrice
        final dp = f.packageDiscountPercent.trim().isEmpty ? null : double.tryParse(f.packageDiscountPercent.replaceAll(',', '.').trim());
        final mp = f.fixedMonthlyPrice.trim().isEmpty ? null : double.tryParse(f.fixedMonthlyPrice.replaceAll(',', '.').trim());
        if ((dp == null || dp <= 0 || dp > 100) && (mp == null || mp <= 0)) {
          out['package'] = 'Set discount% or fixed monthly price';
        }
        if (![3, 6, 9, 12].contains(f.packageMonths)) out['package'] = 'Choose 3/6/9/12 months';
        break;

      case OfferType.bonus:
        if (f.bonusText.trim().length < 3) out['bonus'] = 'Bonus text is required';
        break;
    }

    return out.isEmpty ? null : out;
  }

  OfferEntity _buildOffer(String id, OffersCreateForm f) {
    final durationValue = int.tryParse(f.durationValue.trim());
    final discountPercent = double.tryParse(f.discountPercent.replaceAll(',', '.').trim());
    final fixedPriceValue = double.tryParse(f.fixedPriceValue.replaceAll(',', '.').trim());
    final pkgDiscount = double.tryParse(f.packageDiscountPercent.replaceAll(',', '.').trim());
    final fixedMonthly = double.tryParse(f.fixedMonthlyPrice.replaceAll(',', '.').trim());

    return OfferEntity(
      id: id,
      title: f.title.trim(),
      type: f.type,
      validUntil: f.validUntil.trim(),
      enabled: f.enabled,
      durationValue: durationValue,
      durationUnit: (durationValue == null) ? null : f.durationUnit,
      discountPercent: f.type == OfferType.discountPercent ? discountPercent : null,
      fixedPriceValue: f.type == OfferType.fixedPriceOverride ? fixedPriceValue : null,
      fixedPriceUnit: f.type == OfferType.fixedPriceOverride ? f.fixedPriceUnit : null,
      packageMonths: f.type == OfferType.packageMonths ? f.packageMonths : null,
      packageDiscountPercent: f.type == OfferType.packageMonths ? pkgDiscount : null,
      fixedMonthlyPrice: f.type == OfferType.packageMonths ? fixedMonthly : null,
      bonusText: f.type == OfferType.bonus ? f.bonusText.trim() : null,
    );
  }
}


