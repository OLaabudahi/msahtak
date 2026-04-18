import 'dart:convert';
import 'package:http/http.dart' as http;

class AiConciergeRemoteSource {
  static const _productionChatUrl = 'https://masahatak-admin.vercel.app/api/ai/chat';

  Future<String> sendMessage({
    required String message,
    required String lang,
  }) async {
    const endpoint = _productionChatUrl;

    try {
      final uri = Uri.parse(endpoint);
      final response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'lang': lang,
        }),
      );


      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _fallbackResponse(message: message, lang: lang);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final text = decoded['text']?.toString().trim() ?? '';
        if (text.isNotEmpty) {
          return text;
        }
      }

      return _fallbackResponse(message: message, lang: lang);
    } catch (_) {
      return _fallbackResponse(message: message, lang: lang);
    }
  }

  String _fallbackResponse({required String message, required String lang}) {
    final lower = message.toLowerCase();
    final wantsBooking = lower.contains('book') || lower.contains('reserve') || message.contains('حجز');

    if (wantsBooking) {
      return lang == 'ar'
          ? 'يمكنني مساعدتك في الحجز. [ACTION:space_001]'
          : 'I can help you with booking. [ACTION:space_001]';
    }

    return lang == 'ar'
        ? 'شكرًا، وضّح أكثر حتى أساعدك بشكل أفضل.'
        : 'Thanks, share more details so I can help better.';
  }
}
