import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/user_profile_bloc.dart';
import '../bloc/user_profile_event.dart';
import '../bloc/user_profile_state.dart';
import '../data/repos/user_profile_repo_impl.dart';
import '../data/sources/user_profile_dummy_source.dart';
import '../domain/usecases/add_user_note_usecase.dart';
import '../domain/usecases/approve_user_usecase.dart';
import '../domain/usecases/block_user_usecase.dart';
import '../domain/usecases/get_user_profile_usecase.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  const UserProfilePage({super.key, required this.userId});

  static Widget withBloc({required String userId}) {
    final source = UserProfileDummySource();
    final repo = UserProfileRepoImpl(source);
    return BlocProvider(
      create: (_) => UserProfileBloc(
        getProfile: GetUserProfileUseCase(repo),
        approve: ApproveUserUseCase(repo),
        block: BlockUserUseCase(repo),
        addNote: AddUserNoteUseCase(repo),
      )..add(UserProfileStarted(userId)),
      child: UserProfilePage(userId: userId),
    );
  }

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _openNoteSheet(BuildContext context) async {
    _note.text = '';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdminColors.bg,
      barrierColor: const Color(0x66000000),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: AdminRadii.r24)),
      builder: (ctx) {
        final inset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Note', style: AdminText.h2()),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _note,
                      maxLines: 4,
                      style: AdminText.body16(),
                      decoration: InputDecoration(
                        hintText: 'Write a note...',
                        hintStyle: AdminText.body16(color: AdminColors.black40),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: AdminButton.outline(label: 'Back', onTap: () => Navigator.of(ctx).pop(), bg: AdminColors.black15, fg: AdminColors.text)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AdminButton.filled(
                            label: 'Save',
                            onTap: () {
                              final t = _note.text.trim();
                              if (t.isEmpty) return;
                              Navigator.of(ctx).pop();
                              context.read<UserProfileBloc>().add(UserProfileAddNotePressed(widget.userId, t));
                            },
                            bg: AdminColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state.profile == null) {
              return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
            }

            final p = state.profile!;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(title: 'User Profile', subtitle: 'User details & actions', onBack: () => Navigator.of(context).maybePop()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AdminCard(
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(color: AdminColors.primaryBlue, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(p.avatar, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(color: Colors.white, w: FontWeight.w600)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text('Internal Rating: ${p.internalRating}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75)),
                                    Text('No-show: ${p.noShowCount}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Booking History', style: AdminText.h2()),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AdminCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: p.bookingHistory
                                .map((id) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text('Booking ID: $id', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600)),
                                    ))
                                .toList(growable: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            AdminButton.filled(label: 'Approve / Activate', onTap: () => context.read<UserProfileBloc>().add(UserProfileApprovePressed(widget.userId)), bg: AdminColors.success),
                            const SizedBox(height: 12),
                            AdminButton.outline(label: 'Block', onTap: () => context.read<UserProfileBloc>().add(UserProfileBlockPressed(widget.userId)), bg: AdminColors.danger, fg: AdminColors.danger),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () => _openNoteSheet(context),
                              borderRadius: BorderRadius.circular(12),
                              child: AdminCard(
                                child: Row(
                                  children: [
                                    Icon(AdminIconMapper.note(), size: 18, color: AdminColors.primaryBlue),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text('Add Note', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600))),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
