import 'package:flutter/material.dart';

class LocalizationService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  void toggleLanguage() {
    _currentLocale = _currentLocale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  // Translations
  Map<String, Map<String, String>> translations = {
    'en': {
      'login': 'Login',
      'signUp': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'fullName': 'Full Name',
      'forgetPassword': 'Forget Password?',
      'dontHaveAccount': "Don't have an account? ",
      'youHaveAccount': 'You have an account? ',
      'or': 'or',
      'english': 'English',
      'arabic': 'العربية',
      'pleaseWait': 'Please wait...',
      'pleaseFillAllFields': 'Please fill all fields',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordLength': 'Password must be at least 6 characters',
      'accountCreated': 'Account created successfully!',
      'welcomeUser': 'Welcome! You are logged in as ',
      'pleaseEnterEmail': 'Please enter your email first',
      'passwordResetSent': 'Password reset email sent!',
      'appleSignInNotAvailable': 'Apple Sign-In requires Apple Developer Account',
    },
    'ar': {
      'login': 'تسجيل الدخول',
      'signUp': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'fullName': 'الاسم الكامل',
      'forgetPassword': 'نسيت كلمة المرور؟',
      'dontHaveAccount': 'ليس لديك حساب؟ ',
      'youHaveAccount': 'لديك حساب؟ ',
      'or': 'أو',
      'english': 'English',
      'arabic': 'العربية',
      'pleaseWait': 'الرجاء الانتظار...',
      'pleaseFillAllFields': 'الرجاء ملء جميع الحقول',
      'passwordsDoNotMatch': 'كلمات المرور غير متطابقة',
      'passwordLength': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'accountCreated': 'تم إنشاء الحساب بنجاح!',
      'welcomeUser': 'مرحباً! تم تسجيل دخولك كـ ',
      'pleaseEnterEmail': 'الرجاء إدخال بريدك الإلكتروني أولاً',
      'passwordResetSent': 'تم إرسال بريد إعادة تعيين كلمة المرور!',
      'appleSignInNotAvailable': 'تسجيل الدخول بـ Apple يتطلب حساب مطور Apple',
    },
  };

  String translate(String key) {
    return translations[_currentLocale.languageCode]?[key] ?? key;
  }

  String t(String key) => translate(key);
}
