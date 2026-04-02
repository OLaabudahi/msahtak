import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/amenity_entity.dart';
import '../domain/entities/policy_section_entity.dart';
import '../domain/entities/price_unit.dart';
import '../domain/entities/space_form_entity.dart';
import '../domain/entities/space_location_entity.dart';
import '../domain/entities/week_day.dart';
import '../domain/entities/working_hours_entity.dart';
import '../domain/usecases/add_amenity_usecase.dart';
import '../domain/usecases/get_amenity_catalog_usecase.dart';
import '../domain/usecases/get_space_form_usecase.dart';
import '../domain/usecases/save_space_usecase.dart';

import 'add_edit_space_event.dart';
import 'add_edit_space_state.dart';

class AddEditSpaceBloc extends Bloc<AddEditSpaceEvent, AddEditSpaceState> {
  final GetSpaceFormUseCase getForm;
  final SaveSpaceUseCase save;
  final GetAmenityCatalogUseCase getAmenityCatalog;
  final AddAmenityUseCase addAmenity;

  AddEditSpaceBloc({
    required this.getForm,
    required this.save,
    required this.getAmenityCatalog,
    required this.addAmenity,
  }) : super(AddEditSpaceState.initial()) {
    on<AddEditSpaceStarted>(_onStarted);
    on<AddEditSpaceAmenityCatalogRequested>(_onAmenityCatalog);
    on<AddEditSpaceAmenityToggled>(_onAmenityToggle);
    on<AddEditSpaceAmenityAddRequested>(_onAmenityAdd);

    on<AddEditSpaceFieldChanged>(_onField);
    on<AddEditSpaceHiddenToggled>(_onHidden);
    on<AddEditSpaceBasePriceChanged>(_onBasePrice);
    on<AddEditSpaceBaseUnitChanged>(_onBaseUnit);
    on<AddEditSpaceLocationSet>(_onLocation);

    on<AddEditSpaceWorkingDayEnabledToggled>(_onWorkingEnabled);
    on<AddEditSpaceWorkingDayClosedToggled>(_onWorkingClosed);
    on<AddEditSpaceWorkingTimeChanged>(_onWorkingTime);

    on<AddEditSpacePolicySectionAdded>(_onPolicyAddSection);
    on<AddEditSpacePolicySectionRemoved>(_onPolicyRemoveSection);
    on<AddEditSpacePolicySectionTitleChanged>(_onPolicyTitle);
    on<AddEditSpacePolicyBulletAdded>(_onPolicyAddBullet);
    on<AddEditSpacePolicyBulletRemoved>(_onPolicyRemoveBullet);

    on<AddEditSpaceImageAdded>(_onImageAdded);
    on<AddEditSpaceImageRemoved>(_onImageRemoved);
    on<AddEditSpaceSeatsChanged>(_onSeats);
    on<AddEditSpaceAdminChanged>(_onAdmin);
    on<AddEditSpacePaymentMethodAdded>(_onPaymentMethodAdded);
    on<AddEditSpacePaymentMethodRemoved>(_onPaymentMethodRemoved);
    on<AddEditSpacePaymentFieldChanged>(_onPaymentFieldChanged);
    on<AddEditSpaceSavePressed>(_onSave);
  }

  Future<void> _onStarted(AddEditSpaceStarted event, Emitter<AddEditSpaceState> emit) async {
    emit(state.copyWith(status: AddEditSpaceStatus.loading, error: null));
    try {
      final form = await getForm(spaceId: event.spaceId);
      final normalized = _normalizeDefaults(form);
      emit(state.copyWith(
        status: AddEditSpaceStatus.ready,
        form: _deriveCompat(normalized),
        clearNameError: true,
        clearAddressError: true,
        clearBasePriceError: true,
        clearWorkingHoursError: true,
        clearPoliciesError: true,
      ));
      add(const AddEditSpaceAmenityCatalogRequested());
    } catch (e) {
      emit(state.copyWith(status: AddEditSpaceStatus.failure, error: e.toString()));
    }
  }

  SpaceFormEntity _normalizeDefaults(SpaceFormEntity f) {
    final wh = f.workingHours.isNotEmpty ? f.workingHours : _defaultWorkingHours();
    return SpaceFormEntity(
      id: f.id,
      name: f.name,
      address: f.address,
      description: f.description,
      price: f.price,
      hours: f.hours,
      policies: f.policies,
      basePriceValue: f.basePriceValue,
      basePriceUnit: f.basePriceUnit,
      location: f.location,
      workingHours: wh,
      policySections: f.policySections,
      amenities: f.amenities,
      hidden: f.hidden,
      totalSeats: f.totalSeats,
      adminId: f.adminId,
      adminName: f.adminName,
      paymentMethods: f.paymentMethods,
    );
  }

  List<WorkingHoursEntity> _defaultWorkingHours() {
    const open = '08:00';
    const close = '22:00';
    return const [
      WorkingHoursEntity(day: WeekDay.sun, open: open, close: close, closed: false),
      WorkingHoursEntity(day: WeekDay.mon, open: open, close: close, closed: false),
      WorkingHoursEntity(day: WeekDay.tue, open: open, close: close, closed: false),
      WorkingHoursEntity(day: WeekDay.wed, open: open, close: close, closed: false),
      WorkingHoursEntity(day: WeekDay.thu, open: open, close: close, closed: false),
      WorkingHoursEntity(day: WeekDay.fri, open: open, close: close, closed: true),
      WorkingHoursEntity(day: WeekDay.sat, open: open, close: close, closed: true),
    ];
  }

  Future<void> _onAmenityCatalog(AddEditSpaceAmenityCatalogRequested event, Emitter<AddEditSpaceState> emit) async {
    final f = state.form;
    if (f == null) return;

    emit(state.copyWith(amenityCatalogLoading: true));
    try {
      final catalog = await getAmenityCatalog();
      final selectedIds = f.amenities.where((a) => a.selected).map((a) => a.id).toSet();
      final customInForm = f.amenities.where((a) => a.isCustom).toList(growable: false);

      final merged = <AmenityEntity>[
        ...catalog.map((a) => AmenityEntity(id: a.id, name: a.name, selected: selectedIds.contains(a.id), isCustom: a.isCustom)),
        ...customInForm.where((c) => !catalog.any((a) => a.id == c.id)),
      ];

      emit(state.copyWith(
        amenityCatalogLoading: false,
        form: _deriveCompat(_copyForm(f, amenities: merged)),
      ));
    } catch (e) {
      emit(state.copyWith(amenityCatalogLoading: false, error: e.toString()));
    }
  }

  void _onAmenityToggle(AddEditSpaceAmenityToggled event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    final next = f.amenities.map((a) {
      if (a.id != event.amenityId) return a;
      return AmenityEntity(id: a.id, name: a.name, selected: !a.selected, isCustom: a.isCustom);
    }).toList(growable: false);

    emit(state.copyWith(form: _deriveCompat(_copyForm(f, amenities: next))));
  }

  Future<void> _onAmenityAdd(AddEditSpaceAmenityAddRequested event, Emitter<AddEditSpaceState> emit) async {
    final f = state.form;
    if (f == null) return;
    final name = event.name.trim();
    if (name.isEmpty) return;

    emit(state.copyWith(amenityCatalogLoading: true));
    try {
      final created = await addAmenity(name: name);
      final next = [
        AmenityEntity(id: created.id, name: created.name, selected: true, isCustom: true),
        ...f.amenities,
      ];
      emit(state.copyWith(amenityCatalogLoading: false, form: _deriveCompat(_copyForm(f, amenities: next))));
    } catch (e) {
      emit(state.copyWith(amenityCatalogLoading: false, error: e.toString()));
    }
  }

  void _onField(AddEditSpaceFieldChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    SpaceFormEntity next = f;
    switch (event.field) {
      case 'name':
        next = _copyForm(f, name: event.value);
        emit(state.copyWith(form: _deriveCompat(next), clearNameError: true));
        return;
      case 'address':
        next = _copyForm(f, address: event.value);
        emit(state.copyWith(form: _deriveCompat(next), clearAddressError: true));
        return;
      case 'description':
        next = _copyForm(f, description: event.value);
        emit(state.copyWith(form: _deriveCompat(next)));
        return;
      case 'policiesText':
        next = _copyForm(f, policies: event.value);
        emit(state.copyWith(form: _deriveCompat(next)));
        return;
    }
  }

  void _onHidden(AddEditSpaceHiddenToggled event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, hidden: event.hidden))));
  }

  void _onBasePrice(AddEditSpaceBasePriceChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final cleaned = event.value.replaceAll(',', '.').trim();
    final v = double.tryParse(cleaned) ?? 0;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, basePriceValue: max(0, v))), clearBasePriceError: true));
  }

  void _onBaseUnit(AddEditSpaceBaseUnitChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, basePriceUnit: event.unit))));
  }

  void _onLocation(AddEditSpaceLocationSet event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, location: SpaceLocationEntity(lat: event.lat, lng: event.lng)))));
  }

  void _onWorkingEnabled(AddEditSpaceWorkingDayEnabledToggled event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    final existing = f.workingHours;
    final idx = existing.indexWhere((x) => x.day == event.day);
    final next = List<WorkingHoursEntity>.from(existing);

    if (idx == -1) {
      next.add(WorkingHoursEntity(day: event.day, open: '08:00', close: '22:00', closed: !event.enabled));
    } else {
      final cur = existing[idx];
      next[idx] = WorkingHoursEntity(day: cur.day, open: cur.open, close: cur.close, closed: !event.enabled ? true : false);
    }

    emit(state.copyWith(
      form: _deriveCompat(_copyForm(f, workingHours: _sortWH(next))),
      clearWorkingHoursError: true,
    ));
  }

  void _onWorkingClosed(AddEditSpaceWorkingDayClosedToggled event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    final next = f.workingHours.map((x) {
      if (x.day != event.day) return x;
      return WorkingHoursEntity(day: x.day, open: x.open, close: x.close, closed: event.closed);
    }).toList(growable: false);

    emit(state.copyWith(form: _deriveCompat(_copyForm(f, workingHours: _sortWH(next))), clearWorkingHoursError: true));
  }

  void _onWorkingTime(AddEditSpaceWorkingTimeChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    final next = f.workingHours.map((x) {
      if (x.day != event.day) return x;
      return WorkingHoursEntity(day: x.day, open: event.open, close: event.close, closed: x.closed);
    }).toList(growable: false);

    emit(state.copyWith(form: _deriveCompat(_copyForm(f, workingHours: _sortWH(next))), clearWorkingHoursError: true));
  }

  List<WorkingHoursEntity> _sortWH(List<WorkingHoursEntity> list) {
    int order(WeekDay d) => switch (d) {
          WeekDay.sun => 0,
          WeekDay.mon => 1,
          WeekDay.tue => 2,
          WeekDay.wed => 3,
          WeekDay.thu => 4,
          WeekDay.fri => 5,
          WeekDay.sat => 6,
        };
    list.sort((a, b) => order(a.day).compareTo(order(b.day)));
    return list;
  }

  void _onPolicyAddSection(AddEditSpacePolicySectionAdded event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final id = 'sec_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}';
    final next = [...f.policySections, PolicySectionEntity(id: id, title: 'New Section', bullets: const [])];
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, policySections: next)), clearPoliciesError: true));
  }

  void _onPolicyRemoveSection(AddEditSpacePolicySectionRemoved event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final next = f.policySections.where((s) => s.id != event.sectionId).toList(growable: false);
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, policySections: next)), clearPoliciesError: true));
  }

  void _onPolicyTitle(AddEditSpacePolicySectionTitleChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final next = f.policySections.map((s) {
      if (s.id != event.sectionId) return s;
      return PolicySectionEntity(id: s.id, title: event.title, bullets: s.bullets);
    }).toList(growable: false);
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, policySections: next)), clearPoliciesError: true));
  }

  void _onPolicyAddBullet(AddEditSpacePolicyBulletAdded event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final text = event.text.trim();
    if (text.isEmpty) return;

    final next = f.policySections.map((s) {
      if (s.id != event.sectionId) return s;
      return PolicySectionEntity(id: s.id, title: s.title, bullets: [...s.bullets, text]);
    }).toList(growable: false);

    emit(state.copyWith(form: _deriveCompat(_copyForm(f, policySections: next)), clearPoliciesError: true));
  }

  void _onPolicyRemoveBullet(AddEditSpacePolicyBulletRemoved event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    final next = f.policySections.map((s) {
      if (s.id != event.sectionId) return s;
      final b = List<String>.from(s.bullets);
      if (event.index >= 0 && event.index < b.length) b.removeAt(event.index);
      return PolicySectionEntity(id: s.id, title: s.title, bullets: b);
    }).toList(growable: false);

    emit(state.copyWith(form: _deriveCompat(_copyForm(f, policySections: next)), clearPoliciesError: true));
  }

  void _onImageAdded(AddEditSpaceImageAdded event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final url = event.url.trim();
    if (url.isEmpty) return;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, images: [...f.images, url]))));
  }

  void _onImageRemoved(AddEditSpaceImageRemoved event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final next = List<String>.from(f.images);
    if (event.index >= 0 && event.index < next.length) next.removeAt(event.index);
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, images: next))));
  }

  void _onSeats(AddEditSpaceSeatsChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final v = int.tryParse(event.value.trim()) ?? 0;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, totalSeats: max(0, v)))));
  }

  void _onAdmin(AddEditSpaceAdminChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, adminId: event.adminId, adminName: event.adminName))));
  }

  void _onPaymentMethodAdded(AddEditSpacePaymentMethodAdded event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    if (f.paymentMethods.any((m) => m['id'] == event.id)) return; 
    final next = [...f.paymentMethods, {'id': event.id, 'name': event.name}];
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, paymentMethods: next))));
  }

  void _onPaymentMethodRemoved(AddEditSpacePaymentMethodRemoved event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final next = f.paymentMethods.where((m) => m['id'] != event.id).toList(growable: false);
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, paymentMethods: next))));
  }

  void _onPaymentFieldChanged(AddEditSpacePaymentFieldChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final next = f.paymentMethods.map((m) {
      if (m['id'] != event.id) return m;
      return {...m, event.fieldKey: event.value};
    }).toList(growable: false);
    emit(state.copyWith(form: _deriveCompat(_copyForm(f, paymentMethods: next))));
  }

  Future<void> _onSave(AddEditSpaceSavePressed event, Emitter<AddEditSpaceState> emit) async {
    final f0 = state.form;
    if (f0 == null) return;

    final errors = _validate(f0);
    if (errors.isNotEmpty) {
      emit(state.copyWith(
        nameError: errors['name'],
        addressError: errors['address'],
        basePriceError: errors['basePrice'],
        workingHoursError: errors['workingHours'],
        policiesError: errors['policies'],
      ));
      return;
    }

    emit(state.copyWith(status: AddEditSpaceStatus.saving, error: null));
    try {
      await save(form: _deriveCompat(f0));
      emit(state.copyWith(status: AddEditSpaceStatus.saved));
    } catch (e) {
      emit(state.copyWith(status: AddEditSpaceStatus.failure, error: e.toString()));
    }
  }

  Map<String, String> _validate(SpaceFormEntity f) {
    final out = <String, String>{};

    final name = f.name.trim();
    if (name.isEmpty) out['name'] = 'Name is required';
    else if (name.length < 3) out['name'] = 'Name must be at least 3 characters';
    else if (name.length > 50) out['name'] = 'Name is too long';

    final addr = f.address.trim();
    if (addr.isEmpty) out['address'] = 'Address is required';
    else if (addr.length < 8) out['address'] = 'Address must be at least 8 characters';
    else if (addr.length > 80) out['address'] = 'Address is too long';

    if (f.basePriceValue <= 0) out['basePrice'] = 'Base price must be greater than 0';

    
    final enabled = f.workingHours.where((w) => !w.closed).toList(growable: false);
    if (enabled.isEmpty) {
      out['workingHours'] = 'Select at least one working day';
    } else {
      bool invalidTime = false;
      for (final w in enabled) {
        final o = _toMinutes(w.open);
        final c = _toMinutes(w.close);
        if (o == null || c == null || o >= c) {
          invalidTime = true;
          break;
        }
      }
      if (invalidTime) out['workingHours'] = 'Invalid time range (open must be before close)';
    }

    
    if (f.policySections.isNotEmpty) {
      for (final s in f.policySections) {
        if (s.title.trim().isEmpty) {
          out['policies'] = 'Policy section title cannot be empty';
          break;
        }
        if (s.bullets.where((b) => b.trim().isNotEmpty).isEmpty) {
          out['policies'] = 'Each policy section needs at least 1 bullet';
          break;
        }
      }
    }

    return out;
  }

  int? _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return h * 60 + m;
  }

  
  SpaceFormEntity _copyForm(
    SpaceFormEntity f, {
    String? name,
    String? address,
    String? description,
    String? price,
    String? hours,
    String? policies,
    double? basePriceValue,
    PriceUnit? basePriceUnit,
    SpaceLocationEntity? location,
    List<WorkingHoursEntity>? workingHours,
    List<PolicySectionEntity>? policySections,
    List<AmenityEntity>? amenities,
    List<String>? images,
    bool? hidden,
    int? totalSeats,
    Object? adminId = _sentinel,
    Object? adminName = _sentinel,
    List<Map<String, String>>? paymentMethods,
  }) {
    return SpaceFormEntity(
      id: f.id,
      name: name ?? f.name,
      address: address ?? f.address,
      description: description ?? f.description,
      price: price ?? f.price,
      hours: hours ?? f.hours,
      policies: policies ?? f.policies,
      basePriceValue: basePriceValue ?? f.basePriceValue,
      basePriceUnit: basePriceUnit ?? f.basePriceUnit,
      location: location ?? f.location,
      workingHours: workingHours ?? f.workingHours,
      policySections: policySections ?? f.policySections,
      amenities: amenities ?? f.amenities,
      images: images ?? f.images,
      hidden: hidden ?? f.hidden,
      totalSeats: totalSeats ?? f.totalSeats,
      adminId: adminId == _sentinel ? f.adminId : adminId as String?,
      adminName: adminName == _sentinel ? f.adminName : adminName as String?,
      paymentMethods: paymentMethods ?? f.paymentMethods,
    );
  }

  static const _sentinel = Object();

  SpaceFormEntity _deriveCompat(SpaceFormEntity f) {
    final unit = switch (f.basePriceUnit) { PriceUnit.week => 'week', PriceUnit.month => 'month', _ => 'day' };
    final priceStr = (f.basePriceValue <= 0) ? f.price : '${f.basePriceValue.toStringAsFixed(f.basePriceValue % 1 == 0 ? 0 : 2)}/$unit';

    final enabledDays = f.workingHours.where((w) => !w.closed).toList(growable: false);
    String hoursStr = f.hours;
    if (enabledDays.isNotEmpty) {
      final open = enabledDays.first.open;
      final close = enabledDays.first.close;
      final days = enabledDays.map((e) => e.day.name.toUpperCase()).toList(growable: false);
      hoursStr = '${days.first}-${days.last}, $open-$close';
    }

    String pol = f.policies;
    if (f.policySections.isNotEmpty) {
      pol = f.policySections.map((s) => '${s.title}: ${s.bullets.join(" • ")}').join('\n');
    }

    return _copyForm(f, price: priceStr, hours: hoursStr, policies: pol);
  }
}
