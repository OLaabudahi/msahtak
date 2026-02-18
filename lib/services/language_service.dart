import 'dart:ui';
import 'local_storage_service.dart';

class AppLanguage {
  final String code;
  final String label;

  const AppLanguage({
    required this.code,
    required this.label,
  });

  Locale get locale => Locale(code);
}

class LanguageService {
  LanguageService(this._storage);

  final LocalStorageService _storage;

  static const supported = <AppLanguage>[
    AppLanguage(code: 'en', label: 'English'),
    AppLanguage(code: 'ar', label: 'العربية'),
  ];

  /// ================================
  /// Load & Save Language
  /// ================================

  Future<AppLanguage> loadLanguage() async {
    final saved = await _storage.getLocaleCode();
    final found = supported.where((e) => e.code == saved).toList();

    if (found.isNotEmpty) return found.first;
    return supported.first;
  }

  Future<void> setLanguage(String code) async {
    await _storage.setLocaleCode(code);
  }

  /// ================================
  /// Translations
  /// ================================

  static final Map<String, Map<String, String>> translations = {
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
      'passwordResetTitle': 'Password Reset',
      'passwordResetBody':
      'A reset email has been sent to your address.\nPlease check your inbox and follow the instructions.',
      'ok': 'OK',
      'send': 'Send',
      'backToLogin': 'Back to Login',
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
      'passwordResetTitle': 'إعادة تعيين كلمة المرور',
      'passwordResetBody':
      'تم ارسال بريد الكتروني الى عنوان بريدك.\nقم بتفقد بريدك ومتابعة الاوامر من هناك.',
      'ok': 'حسنًا',
      'send': 'إرسال',
      'backToLogin': 'العودة لتسجيل الدخول',
    },
  };

  /// Static translator
  static String tr(String code, String key) {
    return translations[code]?[key] ?? key;
  }
}
