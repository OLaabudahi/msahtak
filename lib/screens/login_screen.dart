import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleLogin() async {
    final localization = Provider.of<LocalizationService>(context, listen: false);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage(localization.t('pleaseFillAllFields'));
      return;
    }

    _showMessage('Login demo mode - Firebase disabled', isError: false);
    // setState(() => _isLoading = true);
    // final result = await _authService.signIn(
    //   email: _emailController.text.trim(),
    //   password: _passwordController.text,
    // );
    // setState(() => _isLoading = false);
    // if (result['success']) {
    //   String role = result['role'] ?? 'user';
    //   _showMessage('${localization.t('welcomeUser')}$role', isError: false);
    // } else {
    //   _showMessage(result['error']);
    // }
  }

  Future<void> _handleGoogleSignIn() async {
    final localization = Provider.of<LocalizationService>(context, listen: false);
    _showMessage('Google Sign-In demo mode - Firebase disabled', isError: false);
    // setState(() => _isLoading = true);
    // final result = await _authService.signInWithGoogle();
    // setState(() => _isLoading = false);
    // if (result['success']) {
    //   String role = result['role'] ?? 'user';
    //   _showMessage('${localization.t('welcomeUser')}$role', isError: false);
    // } else {
    //   _showMessage(result['error']);
    // }
  }

  Future<void> _handleForgotPassword() async {
    final localization = Provider.of<LocalizationService>(context, listen: false);

    if (_emailController.text.isEmpty) {
      _showMessage(localization.t('pleaseEnterEmail'));
      return;
    }

    _showMessage('Password reset demo mode - Firebase disabled', isError: false);
    // final result = await _authService.resetPassword(_emailController.text.trim());
    // if (result['success']) {
    //   _showMessage(localization.t('passwordResetSent'), isError: false);
    // } else {
    //   _showMessage(result['error']);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localization, child) {
        return Directionality(
          textDirection: localization.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Header with Title and Language Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localization.t('login'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),

                            // Language Selector
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF4A90E2),  // Blue
                                        Color(0xFFF5A623),  // Orange
                                      ],
                                      stops: [0.0, 1.0],
                                    ).createShader(bounds);
                                  },
                                  child: const Icon(
                                    Icons.language,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFF5A623), width: 2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: localization.currentLocale.languageCode,
                                      isDense: true,
                                      icon: const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFFF5A623)),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      dropdownColor: Colors.white,
                                      elevation: 8,
                                      borderRadius: BorderRadius.circular(8),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'en',
                                          child: Text('English'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'ar',
                                          child: Text('العربية'),
                                        ),
                                      ],
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          localization.setLanguage(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Logo
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

                        // Email Field with Floating Label
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: localization.t('email'),
                            labelStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            floatingLabelStyle: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF5A623), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Password Field with Floating Label
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: localization.t('password'),
                            labelStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            floatingLabelStyle: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF5A623), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5A623),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    localization.t('login'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Forget Password Link
                        Align(
                          alignment: localization.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: _handleForgotPassword,
                            child: Text(
                              localization.t('forgetPassword'),
                              style: const TextStyle(
                                color: Color(0xFF5B8FB9),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Divider with "or"
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[350],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                localization.t('or'),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[350],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Social Login Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Button
                            InkWell(
                              onTap: _isLoading ? null : _handleGoogleSignIn,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD6EAF8),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/google_logo.svg',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 40),

                            // Apple Button
                            InkWell(
                              onTap: () {
                                _showMessage(localization.t('appleSignInNotAvailable'));
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB3E5FC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.apple,
                                    size: 28,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Sign Up Link
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                localization.t('dontHaveAccount'),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  localization.t('signUp'),
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
      },
    );
  }
}
