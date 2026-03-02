import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/add_edit_space_bloc.dart';
import '../bloc/add_edit_space_event.dart';
import '../bloc/add_edit_space_state.dart';
import '../data/repos/add_edit_space_repo_impl.dart';
import '../data/sources/add_edit_space_dummy_source.dart';
import '../domain/usecases/add_amenity_usecase.dart';
import '../domain/usecases/get_amenity_catalog_usecase.dart';
import '../domain/usecases/get_space_form_usecase.dart';
import '../domain/usecases/save_space_usecase.dart';

import '../widgets/amenities_editor.dart';
import '../widgets/location_card.dart';
import '../widgets/policies_editor.dart';
import '../widgets/price_editor.dart';
import '../widgets/working_hours_editor.dart';

class AddEditSpacePage extends StatelessWidget {
  final String? spaceId;
  const AddEditSpacePage({super.key, required this.spaceId});

  static Widget withBloc({required String? spaceId}) {
    final source = AddEditSpaceDummySource();
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
              return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
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

  static Future<(double, double)?> _pickLatLng(BuildContext context, {double? lat, double? lng}) async {
    String latText = lat?.toString() ?? '';
    String lngText = lng?.toString() ?? '';

    return showDialog<(double, double)>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Pick Location', style: AdminText.body16(w: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              onChanged: (v) => latText = v,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              onChanged: (v) => lngText = v,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            const SizedBox(height: 8),
            Text('Map picker will be added later (API-ready).', style: AdminText.label12(color: AdminColors.black40)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: Text('Cancel', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700))),
          TextButton(
            onPressed: () {
              final la = double.tryParse(latText.trim());
              final lo = double.tryParse(lngText.trim());
              if (la == null || lo == null) return;
              Navigator.of(ctx).pop((la, lo));
            },
            child: Text('Save', style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
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
