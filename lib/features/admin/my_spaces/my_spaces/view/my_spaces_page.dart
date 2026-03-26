import 'package:Msahtak/core/services/firestore_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../bloc/my_spaces_bloc.dart';
import '../bloc/my_spaces_event.dart';
import '../bloc/my_spaces_state.dart';
import '../data/repos/my_spaces_repo_impl.dart';
import '../data/sources/my_spaces_firebase_source.dart';
import '../domain/usecases/get_my_spaces_usecase.dart';
import '../domain/usecases/hide_space_usecase.dart';
import '../domain/usecases/delete_space_usecase.dart';
import '../widgets/space_card.dart';

import '../../add_edit_space/view/add_edit_space_page.dart';

class MySpacesPage extends StatelessWidget {
  const MySpacesPage({super.key});

  static Widget withBloc() {
    final source = MySpacesFirebaseSource(FirestoreApi());
    final repo = MySpacesRepoImpl(source);
    return BlocProvider(
      create: (_) => MySpacesBloc(
        getSpaces: GetMySpacesUseCase(repo),
        hideSpace: HideSpaceUseCase(repo),
        deleteSpace: DeleteSpaceUseCase(repo),
      )..add(const MySpacesStarted()),
      child: const MySpacesPage(),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String spaceId, String spaceName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.t('adminDeleteSpace')),
        content: Text('"$spaceName" — ${context.t('adminDeleteSpaceConfirm')}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.t('cancel'))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t('adminDelete'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<MySpacesBloc>().add(MySpacesDeletePressed(spaceId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      floatingActionButton: FloatingActionButton(
        heroTag: 'my_spaces_fab',
        backgroundColor: AdminColors.primaryBlue,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEditSpacePage.withBloc(spaceId: null)));
        },
        child: Icon(AdminIconMapper.plus(), color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminAppBar(title: context.t('adminMySpaces'), subtitle: context.t('adminMySpacesSubtitle')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AdminSpace.s16),
                  child: BlocBuilder<MySpacesBloc, MySpacesState>(
                    builder: (context, state) {
                      final list = state.spaces;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AdminSpace.s12),
                        itemBuilder: (ctx, i) => SpaceCard(
                          space: list[i],
                          onManage: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEditSpacePage.withBloc(spaceId: list[i].id))),
                          onHide: () => context.read<MySpacesBloc>().add(MySpacesHidePressed(list[i].id)),
                          onDelete: () => _confirmDelete(context, list[i].id, list[i].name),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


