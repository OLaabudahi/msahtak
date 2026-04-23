class ApiService {
  ApiService._();

  static const String baseUrl = 'https://masahatak-admin.vercel.app';

  static String normalizeBaseUrl(String value) {
    return value.replaceAll(RegExp(r'/$'), '');
  }

  static Uri aiChatUri({String? base}) {
    final normalizedBase = normalizeBaseUrl(base ?? baseUrl);
    return Uri.parse('$normalizedBase/api/ai/chat');
  }

  static Uri sendBookingNotificationUri({String? base}) {
    final normalizedBase = normalizeBaseUrl(base ?? baseUrl);
    return Uri.parse('$normalizedBase/send-booking-notification');
  }

  static Uri aiFinalizeUri({String? base}) {
    final normalizedBase = normalizeBaseUrl(base ?? baseUrl);
    return Uri.parse('$normalizedBase/api/ai/finalize');
  }
}
