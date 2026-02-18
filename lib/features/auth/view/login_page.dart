import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_start/bloc/app_start_bloc.dart';
import '../../app_start/bloc/app_start_event.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../services/local_storage_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../data/repos/auth_repo_dummy.dart';
import '../widgets/auth_language_header.dart';
import '../widgets/auth_social_row.dart';
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

  void _notifyAppRoot(BuildContext context) {
    context.read<AppStartBloc>().add(const AppStartStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.success) {
                _notifyAppRoot(context);
              }
              if (state.status == AuthStatus.error && state.errorMessage != null) {
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
                        'assets/images/msahtak_logo.png',
                        width: 200,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 80,
                            alignment: Alignment.center,
                            child: const Text(
                              'Msahtak',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B8FB9),
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

                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : () {
                              FocusScope.of(context).unfocus();
                              context.read<AuthBloc>().add(
                                AuthLoginRequested(
                                  email: _email.text.trim(),
                                  password: _password.text,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5A623),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: loading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : Text(
                              context.t('login'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          context.t('forgetPassword'),
                          style: const TextStyle(
                            color: Color(0xFF5B8FB9),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: Colors.grey)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            context.t('or'),
                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                        ),
                        Expanded(child: Container(height: 1, color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const AuthSocialRow(),

                    const SizedBox(height: 32),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            context.t('dontHaveAccount'),
                            style: const TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SignUpPage()),
                              );
                            },
                            child: Text(
                              context.t('signUp'),
                              style: const TextStyle(
                                color: Color(0xFFF5A623),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
