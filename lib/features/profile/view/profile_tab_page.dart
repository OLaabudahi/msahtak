import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/app_text_styles.dart';
import '../../app_start/bloc/app_start_bloc.dart';
import '../../app_start/bloc/app_start_event.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../constants/app_spacing.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(const ProfileStarted()),
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
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required VoidCallback onPersonalInfo,
    required VoidCallback onUsage,
    required VoidCallback onPaymentsReceipts,
    required VoidCallback onPaymentDetails,
    required VoidCallback onReviews,
    required VoidCallback onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ProfileMenuTile(
            title: 'Personal Info',
            icon: Icons.circle,
            leadingText: 'P',
            onTap: onPersonalInfo,
          ),
          ProfileMenuTile(
            title: 'Your usage',
            icon: Icons.circle,
            leadingText: 'B',
            onTap: onUsage,
          ),
          ProfileMenuTile(
            title: 'Payments & Receipts',
            icon: Icons.circle,
            leadingText: r'$',
            onTap: onPaymentsReceipts,
          ),

          // Payment Details (expandable)
          Column(
            children: [
              ProfileMenuTile(
                title: 'Payment Details',
                icon: Icons.circle,
                leadingText: r'$D',
                showChevronDown: _paymentExpanded,
                onTap: () {
                  setState(() => _paymentExpanded = !_paymentExpanded);
                  onPaymentDetails();
                },
                onChevronTap: () =>
                    setState(() => _paymentExpanded = !_paymentExpanded),
              ),
              if (_paymentExpanded)
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildPaymentRow('Visa', '*** 123'),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildPaymentRow('Expires date', '08/25'),
                    ],
                  ),
                ),
            ],
          ),

          ProfileMenuTile(
            title: 'Reviews & Ratings',
            icon: Icons.star,
            leadingIcon: Icons.star,
            onTap: onReviews,
          ),
          ProfileMenuTile(
            title: 'Saved Spaces',
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
      onTap: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: Transform.scale(
              scaleX: -1,
              child: const Icon(Icons.login, color: Colors.black, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE53935),
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
                          const Text(
                            'Profile',
                            style: AppTextStyles.sectionBarTitle,
                          ),
                          const SizedBox(height: 16),

                          ProfileHeaderCard(user: state.user!),

                          const SizedBox(height: 20),

                          _buildMenuSection(
                            onPersonalInfo: () {},
                            onUsage: () {},
                            onPaymentsReceipts: () {},
                            onPaymentDetails: () {},
                            onReviews: () {},
                            onSaved: () {},
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
