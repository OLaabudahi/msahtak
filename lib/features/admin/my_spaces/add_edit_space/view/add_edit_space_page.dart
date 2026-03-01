import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/add_edit_space_bloc.dart';
import '../bloc/add_edit_space_event.dart';
import '../bloc/add_edit_space_state.dart';
import '../data/repos/add_edit_space_repo_impl.dart';
import '../data/sources/add_edit_space_dummy_source.dart';
import '../domain/usecases/get_space_form_usecase.dart';
import '../domain/usecases/save_space_usecase.dart';
import '../widgets/chip_toggle.dart';

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
            if (state.form == null) {
              return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
            }

            final f = state.form!;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: (spaceId == null) ? 'Add Space' : 'Edit Space',
                        subtitle: 'Update your space info',
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AdminSpace.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Availability inside edit
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

                            _Field(label: 'Name', value: f.name, hint: 'Space name', onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('name', v))),
                            const SizedBox(height: 12),
                            _Field(label: 'Address', value: f.address, hint: 'Space address', onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('address', v))),
                            const SizedBox(height: 12),
                            _Field(label: 'Price', value: f.price, hint: '\$ / hour', onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('price', v))),
                            const SizedBox(height: 12),
                            _Field(label: 'Description', value: f.description, hint: 'Write a description...', maxLines: 4, onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('description', v))),

                            const SizedBox(height: 16),
                            Text('Amenities', style: AdminText.h2()),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: f.amenities
                                  .map((a) => ChipToggle(
                                        label: a.name,
                                        selected: a.selected,
                                        onTap: () => context.read<AddEditSpaceBloc>().add(AddEditSpaceAmenityToggled(a.id)),
                                      ))
                                  .toList(growable: false),
                            ),

                            const SizedBox(height: 16),
                            AdminCard(
                              child: Row(
                                children: [
                                  Icon(AdminIconMapper.upload(), size: 18, color: AdminColors.primaryBlue),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Upload Photos (carousel)', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700))),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                            _Field(label: 'Working Hours', value: f.hours, hint: 'e.g. Sun-Thu 9:00 - 19:00', onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('hours', v))),
                            const SizedBox(height: 12),
                            _Field(label: 'Policies', value: f.policies, hint: 'Space policies...', maxLines: 4, onChanged: (v) => context.read<AddEditSpaceBloc>().add(AddEditSpaceFieldChanged('policies', v))),

                            const SizedBox(height: 16),
                            AdminButton.filled(
                              label: (state.status == AddEditSpaceStatus.saving) ? 'Saving...' : 'Save',
                              onTap: (state.status == AddEditSpaceStatus.saving) ? null : () => context.read<AddEditSpaceBloc>().add(const AddEditSpaceSavePressed()),
                              bg: AdminColors.primaryBlue,
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final String hint;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _Field({
    required this.label,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: maxLines,
          style: AdminText.body16(color: AdminColors.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AdminText.body16(color: AdminColors.black40),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
          ),
        ),
      ],
    );
  }
}
