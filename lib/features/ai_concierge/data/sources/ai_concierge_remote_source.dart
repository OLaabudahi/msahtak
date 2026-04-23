import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/services/api/api_service.dart';

class AiConciergeRemoteSource {
  Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String userId,
    required List<Map<String, dynamic>> history,
    required List<String> lastSpaces,
  }) async {
    try {
      final uri = ApiService.aiChatUri();
      final response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'userId': userId,
          'history': history,
          'lastSpaces': lastSpaces,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _fallbackResponse(message: message);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final text = decoded['text']?.toString().trim() ?? '';
        final spaces = _parseSpaces(decoded['currentSpaces']);
        if (text.isNotEmpty) {
          return {'text': text, 'currentSpaces': spaces};
        }
      }

      return _fallbackResponse(message: message);
    } catch (_) {
      return _fallbackResponse(message: message);
    }
  }

  Future<void> finalizeSession({
    required String userId,
    required List<Map<String, dynamic>> history,
  }) async {
    if (userId.trim().isEmpty || history.isEmpty) return;

    try {
      final uri = ApiService.aiFinalizeUri();
      await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'history': history,
        }),
      );
    } catch (_) {
      // silent by design
    }
  }

  List<Map<String, dynamic>> _parseSpaces(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Map<String, dynamic> _fallbackResponse({required String message}) {
    final lower = message.toLowerCase();
    final wantsBooking =
        lower.contains('book') || lower.contains('reserve') || message.contains('حجز');
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);

    return {
      'text': wantsBooking
          ? (isArabic
              ? 'يمكنني مساعدتك في الحجز. [ACTION:space_001]'
              : 'I can help you with booking. [ACTION:space_001]')
          : (isArabic
              ? 'شكرًا، وضّح أكثر حتى أساعدك بشكل أفضل.'
              : 'Thanks, share more details so I can help better.'),
      'currentSpaces': <Map<String, dynamic>>[],
    };
  }
}
