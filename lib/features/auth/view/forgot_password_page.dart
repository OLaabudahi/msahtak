import 'package:flutter/material.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _showSentDialogAndBack(BuildContext pageContext) async {
    await showDialog<void>(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.t('passwordResetTitle')),
        content: Text(dialogContext.t('passwordResetBody')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child:  Text(dialogContext.t('ok')),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(pageContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            context.t('forgotPassword'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state.status == AuthStatus.forgotSent) {
                await _showSentDialogAndBack(context);
              }
              if (state.status == AuthStatus.error &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    Text(context.t('enterEmail')),

                    const SizedBox(height: 32),

                    AuthTextField(
                      label: context.t('email'),
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 28),

                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (p, c) => p.status != c.status,
                      builder: (context, state) {
                        return AuthPrimaryButton(
                          title: context.t('send'),
                          loading: state.status == AuthStatus.loading,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            context.read<AuthBloc>().add(
                              AuthForgotPasswordRequested(email: _email.text),
                            );
                          },
                        );
                      },
                    ),
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
