import 'package:Msahtak/constants/app_assets.dart';
import 'package:flutter/material.dart';
import '../../../core/services/firestore_api.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_root.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../core/widgets/app_button.dart';
import '../../app_start/bloc/app_start_bloc.dart';
import '../../app_start/bloc/app_start_event.dart';
import '../../space_requests/bloc/space_request_bloc.dart';
import '../../space_requests/data/repos/space_request_repo_impl.dart';
import '../../space_requests/data/sources/space_request_firebase_source.dart';
import '../../space_requests/domain/usecases/submit_space_request_usecase.dart';
import '../../space_requests/view/space_request_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_language_header.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apple = context.t('apple');
    return Directionality(
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (!mounted) return;
              if (state.status == AuthStatus.success) {
                context.read<AppStartBloc>().add(const AppStartStarted());
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AppRoot.withBloc()),
                  (route) => false,
                );
              }
              if (state.status == AuthStatus.error &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    AuthLanguageHeader(titleKey: 'login'),

                    const SizedBox(height: 24),

                    Center(
                      child: Image.asset(
                        AppAssets.logo,
                        width: 200,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 80,
                            alignment: Alignment.center,
                            child: Text(
                              context.t('msahtak'),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 50),

                    AuthTextField(
                      controller: _email,
                      label: context.t('email'),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),

                    AuthTextField(
                      controller: _password,
                      label: context.t('password'),
                      obscureText: true,
                    ),

                    const SizedBox(height: 32),

                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (p, c) => p.status != c.status,
                      builder: (context, state) {
                        final loading = state.status == AuthStatus.loading;

                        return AppButton(
                          width: double.infinity,
                          height: 50,
                          borderRadius: 25,
                          loading: loading,
                          label: context.t('login'),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            context.read<AuthBloc>().add(
                                  AuthLoginRequested(
                                    email: _email.text.trim(),
                                    password: _password.text,
                                  ),
                                );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: context.isArabic
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          context.t('forgetPassword'),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            context.t('or'),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<AuthBloc>().add(
                              AuthGoogleLoginRequested(),
                            );
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryTint25,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.g_mobiledata,
                                size: 34,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(apple),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryTint25,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.apple,
                                size: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            context.t('dontHaveAccount'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              context.t('signUp'),
                              style: const TextStyle(
                                color: AppColors.amber,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => SpaceRequestBloc(
                                SubmitSpaceRequestUseCase(
                                  SpaceRequestRepoImpl(
                                    SpaceRequestFirebaseSource(FirestoreApi()),
                                  ),
                                ),
                              ),
                              child: const SpaceRequestPage(),
                            ),
                          ),
                        );
                        if (!mounted) return;
                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.t('requestSuccessFull'),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          context.t( 'joinMsahtak'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.amber,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
