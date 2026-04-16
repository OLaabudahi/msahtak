import 'dart:convert';
import 'package:http/http.dart' as http;
Future<void> testGeminiDirectly() async {
  const String myApiKey = 'AIzaSyDReqVVVb_MfdxioHYILPKCz6wjRGDcFfs';

  // الرابط بصيغة مختلفة (v1beta1) وبدون تكرار كلمة models
  const String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$myApiKey';

  try {
    print("محاولة أخيرة مع التنسيق الجديد...");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "user", // أضفنا الـ role ليكون الطلب نظامياً
            "parts": [
              {"text": "مرحباً جيمي، هل تسمعني؟"}
            ]
          }
        ],
        "generationConfig": { // أضفنا إعدادات بسيطة لتقوية الطلب
          "temperature": 1,
          "topK": 64,
          "topP": 0.95,
          "maxOutputTokens": 8192,
          "responseMimeType": "text/plain"
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ أخيراً! الرد: ${data['candidates'][0]['content']['parts'][0]['text']}");
    } else {
      print("❌ الكود: ${response.statusCode}");
      print("الرد من السيرفر: ${response.body}");
    }
  } catch (e) {
    print("⚠️ خطأ: $e");
  }
}