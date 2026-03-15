import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/add_edit_space_bloc.dart';
import '../bloc/add_edit_space_event.dart';
import '../../../_shared/admin_session.dart';
import '../bloc/add_edit_space_state.dart';
import '../data/repos/add_edit_space_repo_impl.dart';
import '../data/sources/add_edit_space_firebase_source.dart';
import '../domain/usecases/add_amenity_usecase.dart';
import '../domain/usecases/get_amenity_catalog_usecase.dart';
import '../domain/usecases/get_space_form_usecase.dart';
import '../domain/usecases/save_space_usecase.dart';

import '../widgets/amenities_editor.dart';
import '../widgets/images_editor.dart';
import '../widgets/location_card.dart';
import 'location_picker_page.dart';
import '../widgets/policies_editor.dart';
import '../widgets/price_editor.dart';
import '../widgets/working_hours_editor.dart';

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
              Navigator.of(context).maybePop();
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
                        Text(state.error ?? 'Failed to load space', style: AdminText.body14(), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        AdminButton.filled(
                          label: 'Retry',
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

            final baseText = (f.basePriceValue <= 0) ? '' : (f.basePriceValue % 1 == 0 ? f.basePriceValue.toStringAsFixed(0) : f.basePriceValue.toStringAsFixed(2));
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
                          title: (spaceId == null) ? 'Add Space' : 'Edit Space',
                          subtitle: 'Update your space info',
                          onBack: () => Navigator.of(context).maybePop(),
                        ),

                        AdminCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Availability', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(f.hidden ? 'Hidden' : 'Available', style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600)),
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
                          label: 'Name',
                          value: f.name,
                          hint: 'Space name',
                          errorText: state.nameError,
                          onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('name', v)),
                        ),
                        const SizedBox(height: 12),
                        _Field(
                          label: 'Address (text)',
                          value: f.address,
                          hint: 'e.g. 12 King St, Downtown',
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
                          valueText: baseText,
                          unit: f.basePriceUnit,
                          errorText: state.basePriceError,
                          onValueChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceBasePriceChanged(v)),
                          onUnitChanged: (u) => context.read<AddEditSpaceBloc>().add(AddEditSpaceBaseUnitChanged(u)),
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
                                  Text('Total Seats', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
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
                                  hintText: 'e.g. 20',
                                  hintStyle: AdminText.body16(color: AdminColors.black40),
                                  contentPadding: const EdgeInsets.all(14),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                                  suffixText: 'seats',
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
                          label: (state.status == AddEditSpaceStatus.saving) ? 'Saving...' : 'Save',
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
    final picked = await showDialog<({String? id, String? name})>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Assign Sub Admin', style: AdminText.h2()),
        content: SizedBox(
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text('None', style: AdminText.body14(color: AdminColors.black40)),
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
              Text('Space Admin', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
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
                      hasAdmin ? widget.adminName ?? 'Sub Admin' : 'Select sub admin (optional)',
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

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final String hint;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _Field({
    required this.label,
    required this.value,
    required this.hint,
    required this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            maxLength: (label.startsWith('Name')) ? 50 : 80,
            style: AdminText.body16(color: AdminColors.text),
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintStyle: AdminText.body16(color: AdminColors.black40),
              errorText: errorText,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
