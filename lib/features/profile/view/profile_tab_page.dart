import 'package:Msahtak/features/profile/domain/usecases/sync_email_verification_usecase.dart';
import 'package:flutter/material.dart';
import '../../../core/services/firestore_api.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_text_styles.dart';
import '../../app_start/bloc/app_start_bloc.dart';
import '../../app_start/bloc/app_start_event.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../constants/app_spacing.dart';
import '../../auth/view/login_page.dart';
import '../../reviews/view/reviews_page.dart';
import '../../usage/view/profile_usage_page.dart';
import '../data/sources/profile_firebase_source.dart';
import '../domain/usecases/change_password_usecase.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/upload_profile_image_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../domain/usecases/verify_email_usecase.dart';
import 'payments_receipts_page.dart';
import 'personal_info_page.dart';
import 'saved_spaces_page.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../data/repos/profile_repo_firebase.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  static Widget withBloc() {
    final source = ProfileFirebaseSource(FirestoreApi());
    final repo = ProfileRepoFirebase(source);

    return BlocProvider(
      create: (_) => ProfileBloc(
        getProfile: GetProfileUseCase(repo),
        updateProfile: UpdateProfileUseCase(repo),
        changePassword: ChangePasswordUseCase(repo),
        verifyEmail: VerifyEmailUseCase(repo),
        syncEmailVerification: SyncEmailVerificationUseCase(repo),
        uploadProfileImage: UploadProfileImageUseCase(repo),
      )..add(const ProfileStarted()),
      child: const ProfileTabPage(),
    );
  }

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  bool _paymentExpanded = false;

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required VoidCallback onPersonalInfo,
    required VoidCallback onUsage,
    required VoidCallback onPaymentsReceipts,
    required VoidCallback onPaymentDetails,
    required VoidCallback onReviews,
    required VoidCallback onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ProfileMenuTile(
            title: context.t('personalInfo'),
            icon: Icons.circle,
            leadingText: 'P',
            onTap: onPersonalInfo,
          ),
          ProfileMenuTile(
            title: context.t('yourUsage'),
            icon: Icons.circle,
            leadingText: 'B',
            onTap: onUsage,
          ),
          ProfileMenuTile(
            title: context.t('paymentsReceipts'),
            icon: Icons.circle,
            leadingText: r'$',
            onTap: onPaymentsReceipts,
          ),

          Column(
            children: [
              ProfileMenuTile(
                title: context.t('paymentDetails'),
                icon: Icons.circle,
                leadingText: r'$D',
                showChevronDown: _paymentExpanded,
                onTap: onPaymentDetails,
                onChevronTap: onPaymentDetails,
              ),
              if (_paymentExpanded)
                Container(
                  color: AppColors.cardBackground,
                  child: Column(
                    children: [
                      _buildPaymentRow(context.t('paymentCardVisa'), '*** 123'),
                      Divider(height: 1, color: AppColors.borderLight),
                      _buildPaymentRow(
                        context.t('paymentCardExpiresDate'),
                        '08/25',
                      ),
                    ],
                  ),
                ),
            ],
          ),

          ProfileMenuTile(
            title: context.t('reviewsRatings'),
            icon: Icons.star,
            leadingIcon: Icons.star,
            onTap: onReviews,
          ),
          ProfileMenuTile(
            title: context.t('savedSpaces'),
            icon: Icons.favorite,
            leadingIcon: Icons.favorite,
            isLast: true,
            onTap: onSaved,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutRow(BuildContext context) {
    return GestureDetector(
      onTap: () => {context.read<AuthBloc>().add(const AuthLogoutRequested())},
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.danger,
              shape: BoxShape.circle,
            ),
            child: Transform.scale(
              scaleX: -1,
              child: const Icon(Icons.login, color: AppColors.text, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            context.t('logOut'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == AuthStatus.loggedOut) {
          Navigator.of(context).popUntil((r) => r.isFirst);
          context.read<AppStartBloc>().add(const AppStartStarted());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
        }
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final bloc = context.read<ProfileBloc>();

          return SafeArea(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text('Error: ${state.error}'))
                : RefreshIndicator(
                    onRefresh: () async =>
                        bloc.add(const ProfileRefreshRequested()),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            context.t('profileTitle'),
                            style: AppTextStyles.sectionBarTitle,
                          ),
                          const SizedBox(height: 16),

                          ProfileHeaderCard(user: state.user!),

                          const SizedBox(height: 20),

                          _buildMenuSection(
                            context,
                            onPersonalInfo: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: const PersonalInfoPage(),
                                ),
                              ),
                            ) /*  Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PersonalInfoPage(),
                              ),
                            )*/,
                            onUsage: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfileUsagePage.withBloc(),
                              ),
                            ),
                            onPaymentsReceipts: () =>
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const PaymentsReceiptsPage(),
                                  ),
                                ),
                            onPaymentDetails: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.t('comingSoon')),
                                ),
                              );
                            },
                            onReviews: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ReviewsPage.withBloc(),
                              ),
                            ),
                            onSaved: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SavedSpacesPage(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          _buildLogoutRow(context),

                          AppSpacing.vLg,
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
