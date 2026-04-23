import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/space_management_bloc.dart';
import '../bloc/space_management_event.dart';
import '../bloc/space_management_state.dart';
import '../data/repos/space_management_repo_impl.dart';
import '../data/sources/space_management_firebase_source.dart';
import '../domain/usecases/get_space_management_usecase.dart';
import '../domain/usecases/set_space_hidden_usecase.dart';

import '../../../my_spaces/add_edit_space/view/add_edit_space_page.dart';

class SpaceManagementPage extends StatelessWidget {
  final String spaceId;
  const SpaceManagementPage({super.key, required this.spaceId});

  static Widget withBloc({required String spaceId}) {
    final source = SpaceManagementFirebaseSource();
    final repo = SpaceManagementRepoImpl(source);
    return BlocProvider(
      create: (_) => SpaceManagementBloc(
        getSpace: GetSpaceManagementUseCase(repo),
        setHidden: SetSpaceHiddenUseCase(repo),
      )..add(SpaceManagementStarted(spaceId)),
      child: SpaceManagementPage(spaceId: spaceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<SpaceManagementBloc, SpaceManagementState>(
          builder: (context, state) {
            final s = state.space;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: 'Space Management',
                        subtitle: s?.name ?? 'Loading...',
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AdminCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Visibility', style: AdminText.body16(w: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      (s?.hidden ?? false) ? 'Hidden' : 'Available',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w600),
                                    ),
                                  ),
                                  Switch(
                                    value: s?.hidden ?? false,
                                    onChanged: (v) => context.read<SpaceManagementBloc>().add(SpaceManagementHiddenToggled(spaceId, v)),
                                    activeColor: AdminColors.primaryBlue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              AdminButton.filled(
                                label: 'Edit Space',
                                onTap: () async {
                                  final updated = await Navigator.of(context)
                                      .push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => AddEditSpacePage.withBloc(
                                        spaceId: spaceId,
                                      ),
                                    ),
                                  );
                                  if (updated == true && context.mounted) {
                                    context.read<SpaceManagementBloc>().add(
                                          SpaceManagementStarted(spaceId),
                                        );
                                  }
                                },
                                bg: AdminColors.primaryBlue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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

