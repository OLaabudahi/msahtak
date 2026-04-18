import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationApiService {
  NotificationApiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? _defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String _defaultBaseUrl = 'https://masahatak-admin.vercel.app';

  final http.Client _client;
  final String _baseUrl;

  Future<void> sendBookingNotification({
    required String userId,
    required String bookingId,
    required String title,
    required String body,
  }) async {
    final uri = Uri.parse('$_baseUrl/send-booking-notification');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'bookingId': bookingId,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to send notification: ${response.statusCode}');
    }
  }
}
