import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';

import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import '../data/repos/users_repo_impl.dart';
import '../data/sources/users_firebase_source.dart';
import '../domain/entities/user_flag.dart';
import '../domain/usecases/search_users_usecase.dart';
import '../widgets/user_row.dart';

import '../../user_profile/view/user_profile_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  static Widget withBloc() {
    final source = UsersFirebaseSource();
    final repo = UsersRepoImpl(source);
    return BlocProvider(
      create: (_) => UsersBloc(search: SearchUsersUseCase(repo))..add(const UsersStarted()),
      child: const UsersPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminAppBar(title: context.t('adminUsersTitle'), subtitle: context.t('adminUsersSubtitle')),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AdminCard(
                      child: Row(
                        children: [
                          Icon(AdminIconMapper.search(), size: 18, color: AdminColors.black40),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (v) => context.read<UsersBloc>().add(UsersQueryChanged(v)),
                              style: AdminText.body16(),
                              decoration: InputDecoration.collapsed(
                                hintText: context.t('adminSearchUsers'),
                                hintStyle: AdminText.body16(color: AdminColors.black40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<UsersBloc, UsersState>(
                      buildWhen: (p, n) => p.filter != n.filter,
                      builder: (context, state) {
                        return Row(
                          children: [
                            _FilterChip(label: context.t('adminFilterAll'), active: state.filter == UserFlag.all, onTap: () => context.read<UsersBloc>().add(const UsersFilterChanged(UserFlag.all))),
                            const SizedBox(width: 8),
                            _FilterChip(label: context.t('adminFilterNew'), active: state.filter == UserFlag.newUsers, onTap: () => context.read<UsersBloc>().add(const UsersFilterChanged(UserFlag.newUsers))),
                            const SizedBox(width: 8),
                            _FilterChip(label: context.t('adminFilterFlagged'), active: state.filter == UserFlag.flagged, onTap: () => context.read<UsersBloc>().add(const UsersFilterChanged(UserFlag.flagged))),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<UsersBloc, UsersState>(
                      builder: (context, state) {
                        final list = state.users;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => UserRow(
                            user: list[i],
                            onView: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => UserProfilePage.withBloc(userId: list[i].id)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = active ? AdminColors.primaryBlue.withOpacity(0.15) : Colors.transparent;
    final br = active ? AdminColors.primaryBlue.withOpacity(0.15) : AdminColors.black15;
    final fg = active ? AdminColors.primaryBlue : AdminColors.black75;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: br, width: 1)),
          alignment: Alignment.center,
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: fg, w: FontWeight.w600)),
        ),
      ),
    );
  }
}
