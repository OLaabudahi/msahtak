import 'dart:convert';

import 'package:http/http.dart' as http;

class AiConciergeRemoteSource {
  static const _productionChatUrl = 'https://masahatak-admin-bap6.vercel.app/api/ai/chat';
  static const _chatUrlFromEnv = String.fromEnvironment('AI_CHAT_URL', defaultValue: '');
  static const _baseUrlFromEnv = String.fromEnvironment('AI_API_BASE_URL', defaultValue: '');

  Future<String> sendMessage({
    required String message,
    required String lang,
  }) async {
    final endpoint = _resolveEndpoint();

    if (endpoint.isEmpty) {
      return _fallbackResponse(message: message, lang: lang);
    }

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
      throw Exception('network_error');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final text = decoded['text']?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }

    throw Exception('invalid_response');
  }

  String _resolveEndpoint() {
    if (_chatUrlFromEnv.isNotEmpty) {
      return _chatUrlFromEnv;
    }
    if (_baseUrlFromEnv.isNotEmpty) {
      return '$_baseUrlFromEnv/api/ai/chat';
    }
    return _productionChatUrl;
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
