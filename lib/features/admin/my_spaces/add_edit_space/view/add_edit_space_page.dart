import 'package:Msahtak/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';

import '../bloc/add_edit_space_bloc.dart';
import '../bloc/add_edit_space_event.dart';
import '../../../_shared/admin_session.dart';
import '../../../../../features/language/bloc/language_bloc.dart';
import '../../../../../services/language_service.dart';
import '../bloc/add_edit_space_state.dart';
import '../data/repos/add_edit_space_repo_impl.dart';
import '../data/sources/add_edit_space_firebase_source.dart';
import '../domain/usecases/add_amenity_usecase.dart';
import '../domain/usecases/get_amenity_catalog_usecase.dart';
import '../domain/usecases/get_space_form_usecase.dart';
import '../domain/usecases/save_space_usecase.dart';

import '../widgets/amenities_editor.dart';
import '../widgets/images_editor.dart';
import '../widgets/payment_methods_editor.dart';
import '../widgets/location_card.dart';
import 'location_picker_page.dart';
import '../widgets/policies_editor.dart';
import '../widgets/price_editor.dart';
import '../widgets/working_hours_editor.dart';

class AddEditSpacePage extends StatefulWidget {
  final String? spaceId;

  const AddEditSpacePage({super.key, required this.spaceId});

  @override
  State<AddEditSpacePage> createState() => _AddEditSpacePageState();

  static Widget withBloc({required String? spaceId}) {
    final source = AddEditSpaceFirebaseSource();
    final repo = AddEditSpaceRepoImpl(source);
    return BlocProvider(
      create: (_) => AddEditSpaceBloc(
        getForm: GetSpaceFormUseCase(repo),
        save: SaveSpaceUseCase(repo),
        getAmenityCatalog: GetAmenityCatalogUseCase(repo),
        addAmenity: AddAmenityUseCase(repo),
      )..add(AddEditSpaceStarted(spaceId)),
      child: AddEditSpacePage(spaceId: spaceId),
    );
  }
}

class _AddEditSpacePageState extends State<AddEditSpacePage> {
  int currentStep = 0;
  bool _validateStep(AddEditSpaceState s) {
    final f = s.form!;
    switch (currentStep) {
      case 0:
        return f.name.isNotEmpty && f.address.isNotEmpty && f.location != null;

      case 1:
        return f.extraPrices.isNotEmpty &&
            f.images.length >= 2 &&
            f.paymentMethods.isNotEmpty;

      case 2:
        return f.totalSeats > 0 && f.workingHours.any((e) => !e.closed);

      case 3:
        return true;

      default:
        return true;
    }
  }

  void _next(AddEditSpaceState s, bool isSaving) {
    if (!_validateStep(s)) return;

    if (currentStep < 3) {
      setState(() => currentStep++);
    } else {
      context.read<AddEditSpaceBloc>().add(const AddEditSpaceSavePressed());
    }
    if (isSaving){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم حفظ المساحة بنجاح")),
      );
       Navigator.pop(context);

    }
  }

  void _back() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditSpaceBloc, AddEditSpaceState>(
      builder: (context, state) {
        final f = state.form;
        final isSaving = state.status == AddEditSpaceStatus.saving;

        if (f == null) return const Center(child: CircularProgressIndicator());

        final isValid = _validateStep(state);
        return Scaffold(
          backgroundColor: AdminColors.bg,
          body: SafeArea(
            child: Column(
              children: [
                /// 🔥 HEADER
                AdminAppBar(
                  title: widget.spaceId == null ? "Add Space" : "Edit Space",
                  subtitle: "Step ${currentStep + 1} of 4",
                  onBack: _back,
                ),

                /// 🔥 PROGRESS
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(_stepTitle(), style: AdminText.h2()),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: LinearProgressIndicator(trackGap: 2,value: (currentStep + 1) / 4),
                ),

                /// 🔥 BODY
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildStep(state),
                  ),
                ),

                /// 🔥 ACTIONS
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (currentStep > 0)
                        Expanded(
                          child: AdminButton.outline(
                            label: "Back",
                            onTap: _back,
                            bg: AppColors.amber,
                            fg: AppColors.amber,
                          ),
                        ),
                      if (currentStep > 0) const SizedBox(width: 10),
                      Expanded(
                        child: AdminButton.filled(
                          label: isSaving
                              ? "Saving..."
                              : currentStep == 3
                              ? (widget.spaceId == null ? "Add Space" : "Update Space")
                              : "Next",

                          onTap: (isValid) ? () => _next(state,isSaving) : null,

                          bg: isValid?  AdminColors.primaryBlue: AppColors.secondary,
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _stepTitle() {
    switch (currentStep) {
      case 0:
        return "المعلومات الأساسية";
      case 1:
        return "الصور والسعر والدفع";
      case 2:
        return "توافر المساحة";
      case 3:
        return "المميزات والسياسات";
      default:
        return "";
    }
  }

  /// 🔥 STEPS

  Widget _buildStep(AddEditSpaceState state) {
    switch (currentStep) {
      case 0:
        return _stepBasic(state);
      case 1:
        return _stepMediaPricing(state);
      case 2:
        return _stepAvailability(state);
      case 3:
        return _stepDetails(state);
      default:
        return const SizedBox();
    }
  }

  /// 🟢 STEP 1
  Widget _stepBasic(AddEditSpaceState state) {
    final f = state.form!;
    final loc = f.location;

    return ListView(
      children: [
        _Field(
          label: "اسم المساحة",
          value: f.name,
          hint: "مثال: مساحة عمل هادئة للدراسة والعمل",
          errorText: state.nameError,
          onChanged: (v) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceFieldChanged('name', v),
          ),
        ),
        const SizedBox(height: 12),

        _Field(
          label: "العنوان",
          value: f.address,
          hint: "مثال: نابلس - شارع...",
          errorText: state.addressError,
          onChanged: (v) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceFieldChanged('address', v),
          ),
        ),
        const SizedBox(height: 12),

        LocationCard(
          lat: loc?.lat,
          lng: loc?.lng,
          onPick: () async {
            final res = await LocationPickerPage.show(context);
            if (res != null) {
              context.read<AddEditSpaceBloc>().add(
                AddEditSpaceLocationSet(res.$1, res.$2),
              );
            }
          },
        ),

        const SizedBox(height: 12),

        _Field(
          label: "الوصف",
          value: f.description,
          hint:
              "اكتب وصف يحتوي كلمات مفتاحية مثل: هادئ، إنترنت سريع، مناسب للدراسة، قريب من الخدمات...",
          errorText: null,
          onChanged: (v) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceFieldChanged('description', v),
          ),
        ),
      ],
    );
  }

  /// 🟢 STEP 2
  Widget _stepMediaPricing(AddEditSpaceState state) {
    final f = state.form!;

    return ListView(
      children: [
        ImagesEditor(
          images: f.images,
          onAdd: (url) =>
              context.read<AddEditSpaceBloc>().add(AddEditSpaceImageAdded(url)),
          onRemove: (i) =>
              context.read<AddEditSpaceBloc>().add(AddEditSpaceImageRemoved(i)),
        ),
        const SizedBox(height: 12),

        PriceEditor(
          prices: f.extraPrices,
          onAdd: (v, u) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceExtraPriceAdded(value: v, unit: u),
          ),
          onRemove: (i) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceExtraPriceRemoved(index: i),
          ),
        ),

        const SizedBox(height: 12),

        PaymentMethodsEditor(
          selectedMethods: f.paymentMethods,
          onAdd: (id, name) => context.read<AddEditSpaceBloc>().add(
            AddEditSpacePaymentMethodAdded(id: id, name: name),
          ),
          onRemove: (id) => context.read<AddEditSpaceBloc>().add(
            AddEditSpacePaymentMethodRemoved(id: id),
          ),
          onFieldChanged: (id, key, val) =>
              context.read<AddEditSpaceBloc>().add(
                AddEditSpacePaymentFieldChanged(
                  id: id,
                  fieldKey: key,
                  value: val,
                ),
              ),
        ),
      ],
    );
  }

  /// 🟢 STEP 3
  Widget _stepAvailability(AddEditSpaceState state) {
    final f = state.form!;

    return ListView(
      children: [
        SwitchListTile(
          value: f.hidden,
          title: const Text("إتاحة المساحة"),
          onChanged: (v) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceHiddenToggled(v),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: f.totalSeats.toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "عدد المقاعد"),
          onChanged: (v) =>
              context.read<AddEditSpaceBloc>().add(AddEditSpaceSeatsChanged(v)),
        ),

        const SizedBox(height: 12),

        WorkingHoursEditor(
          hours: f.workingHours,
          errorText: state.workingHoursError,
          onDayEnabled: (d, enabled) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceWorkingDayEnabledToggled(d, enabled),
          ),
          onClosed: (d, closed) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceWorkingDayClosedToggled(d, closed),
          ),
          onTimeChanged: (d, o, c) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceWorkingTimeChanged(d, o, c),
          ),
        ),
      ],
    );
  }

  /// 🟢 STEP 4
  Widget _stepDetails(AddEditSpaceState state) {
    final f = state.form!;

    return ListView(
      children: [
        AmenitiesEditor(
          amenities: f.amenities,
          loading: state.amenityCatalogLoading,
          onToggle: (id) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceAmenityToggled(id),
          ),
          onAdd: (name) => context.read<AddEditSpaceBloc>().add(
            AddEditSpaceAmenityAddRequested(name),
          ),
        ),

        const SizedBox(height: 12),

        PoliciesEditor(
          sections: f.policySections,
          errorText: state.policiesError,
          onAddSection: () => context.read<AddEditSpaceBloc>().add(
            const AddEditSpacePolicySectionAdded(),
          ),
          onRemoveSection: (id) => context.read<AddEditSpaceBloc>().add(
            AddEditSpacePolicySectionRemoved(id),
          ),
          onTitleChanged: (id, title) => context.read<AddEditSpaceBloc>().add(
            AddEditSpacePolicySectionTitleChanged(id, title),
          ),
          onAddBullet: (id, text) => context.read<AddEditSpaceBloc>().add(
            AddEditSpacePolicyBulletAdded(id, text),
          ),
          onRemoveBullet: (id, index) => context.read<AddEditSpaceBloc>().add(
            AddEditSpacePolicyBulletRemoved(id, index),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final String hint;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final int maxLength;

  const _Field({
    required this.label,
    required this.value,
    required this.hint,
    required this.errorText,
    required this.onChanged,
    this.maxLength = 80,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AdminText.body14(
              color: AdminColors.black75,
              w: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            maxLength: maxLength,
            style: AdminText.body16(color: AdminColors.text),
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintStyle: AdminText.body16(color: AdminColors.black40),
              errorText: errorText,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AdminColors.black15,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AdminColors.black15,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AdminColors.black15,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*


class AddEditSpacePage extends StatelessWidget {
  final String? spaceId;
  const AddEditSpacePage({super.key, required this.spaceId});

  static Widget withBloc({required String? spaceId}) {
    final source = AddEditSpaceFirebaseSource();
    final repo = AddEditSpaceRepoImpl(source);
    return BlocProvider(
      create: (_) => AddEditSpaceBloc(
        getForm: GetSpaceFormUseCase(repo),
        save: SaveSpaceUseCase(repo),
        getAmenityCatalog: GetAmenityCatalogUseCase(repo),
        addAmenity: AddAmenityUseCase(repo),
      )..add(AddEditSpaceStarted(spaceId)),
      child: AddEditSpacePage(spaceId: spaceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocConsumer<AddEditSpaceBloc, AddEditSpaceState>(
          listenWhen: (p, n) => p.status != n.status,
          listener: (context, state) {
            if (state.status == AddEditSpaceStatus.saved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم حفظ المساحة بنجاح")),
              );
              Navigator.of(context).maybePop();
            }

            if (state.status == AddEditSpaceStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? "حدث خطأ")),
              );
            }
          },
          builder: (context, state) {
            final f = state.form;
            if (f == null) {
              if (state.status == AddEditSpaceStatus.failure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AdminColors.black40),
                        const SizedBox(height: 12),
                        Text(state.error ?? context.t('adminFailedLoad'), style: AdminText.body14(), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        AdminButton.filled(
                          label: context.t('adminRetry'),
                          onTap: () => context.read<AddEditSpaceBloc>().add(AddEditSpaceStarted(spaceId)),
                          bg: AdminColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3)));
            }

            final baseText = (f.basePriceValue <= 0)
                ? ''
                : (f.basePriceValue % 1 == 0
                ? f.basePriceValue.toStringAsFixed(0)
                : f.basePriceValue.toStringAsFixed(2));
            final loc = f.location;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdminAppBar(
                          title: (spaceId == null) ? context.t('adminAddSpace') : context.t('adminEditSpace'),
                          subtitle: context.t('adminUpdateSpaceInfo'),
                          onBack: () => Navigator.of(context).maybePop(),
                        ),

                        AdminCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(context.t('adminAvailability'), style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(f.hidden ? context.t('adminHidden') : context.t('adminAvailable'), style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: f.hidden,
                                onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceHiddenToggled(v)),
                                activeColor: AdminColors.primaryBlue,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        _Field(
                          label: context.t('adminSpaceName'),
                          value: f.name,
                          hint: context.t('adminSpaceNameHint'),
                          maxLength: 50,
                          errorText: state.nameError,
                          onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('name', v)),
                        ),
                        const SizedBox(height: 12),
                        _Field(
                          label: context.t('adminAddressLabel'),
                          value: f.address,
                          hint: context.t('adminAddressHint'),
                          errorText: state.addressError,
                          onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('address', v)),
                        ),

                        const SizedBox(height: 12),

                        LocationCard(
                          lat: loc?.lat,
                          lng: loc?.lng,
                          onPick: () async {
                            final res = await _pickLatLng(context, lat: loc?.lat, lng: loc?.lng);
                            if (res == null) return;
                            context.read<AddEditSpaceBloc>().add(AddEditSpaceLocationSet(res.$1, res.$2));
                          },
                        ),

                        const SizedBox(height: 12),

                        PriceEditor(
                          prices: f.extraPrices,
                          onAdd: (v, u) => context.read<AddEditSpaceBloc>()
                              .add(AddEditSpaceExtraPriceAdded(value: v, unit: u)),
                          onRemove: (i) => context.read<AddEditSpaceBloc>()
                              .add(AddEditSpaceExtraPriceRemoved(index: i)),
                        ),

                        const SizedBox(height: 12),

                        AdminCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.event_seat_outlined, size: 18, color: AdminColors.black75),
                                  const SizedBox(width: 8),
                                  Text(context.t('adminTotalSeats'), style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                initialValue: f.totalSeats == 0 ? '' : f.totalSeats.toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceSeatsChanged(v)),
                                style: AdminText.body16(color: AdminColors.text),
                                decoration: InputDecoration(
                                  hintText: context.t('adminSeatsHint'),
                                  hintStyle: AdminText.body16(color: AdminColors.black40),
                                  contentPadding: const EdgeInsets.all(14),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                                  suffixText: context.t('adminSeats'),
                                  suffixStyle: AdminText.body14(color: AdminColors.black40),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (AdminSession.isSuperAdmin)
                          _AdminPickerCard(
                            adminId: f.adminId,
                            adminName: f.adminName,
                            onChanged: (id, name) => context.read<AddEditSpaceBloc>().add(AddEditSpaceAdminChanged(adminId: id, adminName: name)),
                          ),

                        if (AdminSession.isSuperAdmin) const SizedBox(height: 12),

                        ImagesEditor(
                          images: f.images,
                          onAdd: (url) => context.read<AddEditSpaceBloc>().add(AddEditSpaceImageAdded(url)),
                          onRemove: (i) => context.read<AddEditSpaceBloc>().add(AddEditSpaceImageRemoved(i)),
                        ),

                        const SizedBox(height: 12),

                        WorkingHoursEditor(
                          hours: f.workingHours,
                          errorText: state.workingHoursError,
                          onDayEnabled: (d, enabled) => context.read<AddEditSpaceBloc>().add(AddEditSpaceWorkingDayEnabledToggled(d, enabled)),
                          onClosed: (d, closed) => context.read<AddEditSpaceBloc>().add(AddEditSpaceWorkingDayClosedToggled(d, closed)),
                          onTimeChanged: (d, o, c) => context.read<AddEditSpaceBloc>().add(AddEditSpaceWorkingTimeChanged(d, o, c)),
                        ),

                        const SizedBox(height: 12),

                        AmenitiesEditor(
                          amenities: f.amenities,
                          loading: state.amenityCatalogLoading,
                          onToggle: (id) => context.read<AddEditSpaceBloc>().add(AddEditSpaceAmenityToggled(id)),
                          onAdd: (name) => context.read<AddEditSpaceBloc>().add(AddEditSpaceAmenityAddRequested(name)),
                        ),

                        const SizedBox(height: 12),

                        PaymentMethodsEditor(
                          selectedMethods: f.paymentMethods,
                          onAdd: (id, name) => context
                              .read<AddEditSpaceBloc>()
                              .add(AddEditSpacePaymentMethodAdded(id: id, name: name)),
                          onRemove: (id) => context
                              .read<AddEditSpaceBloc>()
                              .add(AddEditSpacePaymentMethodRemoved(id: id)),
                          onFieldChanged: (id, key, val) => context
                              .read<AddEditSpaceBloc>()
                              .add(AddEditSpacePaymentFieldChanged(id: id, fieldKey: key, value: val)),
                        ),

                        const SizedBox(height: 12),

                        PoliciesEditor(
                          sections: f.policySections,
                          errorText: state.policiesError,
                          onAddSection: () => context.read<AddEditSpaceBloc>().add(const AddEditSpacePolicySectionAdded()),
                          onRemoveSection: (id) => context.read<AddEditSpaceBloc>().add(AddEditSpacePolicySectionRemoved(id)),
                          onTitleChanged: (id, title) => context.read<AddEditSpaceBloc>().add(AddEditSpacePolicySectionTitleChanged(id, title)),
                          onAddBullet: (id, text) => context.read<AddEditSpaceBloc>().add(AddEditSpacePolicyBulletAdded(id, text)),
                          onRemoveBullet: (id, index) => context.read<AddEditSpaceBloc>().add(AddEditSpacePolicyBulletRemoved(id, index)),
                        ),

                        const SizedBox(height: 16),

                        AdminButton.filled(
                          label: (state.status == AddEditSpaceStatus.saving) ? context.t('adminSaving') : context.t('save'),
                          onTap: (state.status == AddEditSpaceStatus.saving) ? null : () => context.read<AddEditSpaceBloc>().add(const AddEditSpaceSavePressed()),
                          bg: AdminColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<(double, double)?> _pickLatLng(BuildContext context, {double? lat, double? lng}) {
    return LocationPickerPage.show(context, lat: lat, lng: lng);
  }
}

class _AdminPickerCard extends StatefulWidget {
  final String? adminId;
  final String? adminName;
  final void Function(String? id, String? name) onChanged;

  const _AdminPickerCard({required this.adminId, required this.adminName, required this.onChanged});

  @override
  State<_AdminPickerCard> createState() => _AdminPickerCardState();
}

class _AdminPickerCardState extends State<_AdminPickerCard> {
  List<({String id, String name})> _subAdmins = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'sub_admin')
          .get();
      final list = snap.docs.map((d) {
        final name = d.data()['fullName'] as String? ?? d.data()['full_name'] as String? ?? 'Unknown';
        return (id: d.id, name: name);
      }).toList();
      if (mounted) setState(() => _subAdmins = list);
    } catch (_) {}
  }

  Future<void> _pick() async {
    final lang = context.read<LanguageBloc>().state.code;
    final titleStr = LanguageService.tr(lang, 'adminAssignSubAdmin');
    final noneStr = LanguageService.tr(lang, 'adminNone');
    final picked = await showDialog<({String? id, String? name})>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(titleStr, style: AdminText.h2()),
        content: SizedBox(
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(noneStr, style: AdminText.body14(color: AdminColors.black40)),
                onTap: () => Navigator.of(context).pop((id: null, name: null)),
              ),
              const Divider(height: 1, color: AdminColors.black15),
              ..._subAdmins.map((s) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AdminColors.primaryBlue.withOpacity(0.12),
                      child: Text(s.name[0].toUpperCase(), style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
                    ),
                    title: Text(s.name, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600)),
                    onTap: () => Navigator.of(context).pop((id: s.id, name: s.name)),
                  ),
                  const Divider(height: 1, color: AdminColors.black15),
                ],
              )),
            ],
          ),
        ),
      ),
    );

    if (picked != null) {
      widget.onChanged(picked.id, picked.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAdmin = widget.adminId != null && widget.adminId!.isNotEmpty;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.admin_panel_settings_outlined, size: 18, color: AdminColors.black75),
              const SizedBox(width: 8),
              Text(context.t('adminSpaceAdmin'), style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _pick,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AdminColors.black15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasAdmin ? widget.adminName ?? context.t('adminSpaceAdmin') : context.t('adminSelectSubAdmin'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: hasAdmin
                          ? AdminText.body14(color: AdminColors.text, w: FontWeight.w600)
                          : AdminText.body14(),
                    ),
                  ),
                  Icon(AdminIconMapper.chevronDown(), size: 16, color: AdminColors.black40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


*/
