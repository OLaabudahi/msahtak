import 'package:flutter/material.dart';
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
        title: const Text('Password Reset'),
        content: const Text(
          'طھظ… ط§ط±ط³ط§ظ„ ط¨ط±ظٹط¯ ط§ظ„ظƒطھط±ظˆظ†ظٹ ط§ظ„ظ‰ ط¹ظ†ظˆط§ظ† ط¨ط±ظٹط¯ظƒ.\n'
          'ظ‚ظ… ط¨طھظپظ‚ط¯ ط¨ط±ظٹط¯ظƒ ظˆظ…طھط§ط¨ط¹ط© ط§ظ„ط§ظˆط§ظ…ط± ظ…ظ† ظ‡ظ†ط§ظƒ.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(pageContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // âœ… ط³ظ‡ظ… ط±ط¬ظˆط¹ ط¹ظ„ظˆظٹ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Forgot Password',
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
            // âœ… ظٹط®ظ„ظٹ ط§ظ„ظ…ط­طھظˆظ‰ ط¨ظ†طµ ط§ظ„ط´ط§ط´ط©
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  const Text(
                    'Enter your email and we will send you instructions.',
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 32),

                  AuthTextField(
                    label: 'Email',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 28),

                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (p, c) => p.status != c.status,
                    builder: (context, state) {
                      return AuthPrimaryButton(
                        title: 'Send',
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
    );
  }
}


