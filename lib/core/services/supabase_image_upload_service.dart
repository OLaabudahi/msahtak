import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SupabaseImageUploadService {
  static const _supabaseUrl = 'https://fbepuxcsyrerfhzpqvmy.supabase.co';
  static const _supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZiZXB1eGNzeXJlcmZoenBxdm15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzg0MjcsImV4cCI6MjA4ODcxNDQyN30.mNJOsm7RGIaX9OMw1c5R-3O9QV9bixoGc0rZKKecOLk';

  Future<String> uploadImage({
    required XFile file,
    required String bucket,
  }) async {
    final bytes = await file.readAsBytes();
    final ext =
        file.name.contains('.') ? file.name.split('.').last.toLowerCase() : 'jpg';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final uploadUrl = '$_supabaseUrl/storage/v1/object/$bucket/$fileName';

    final response = await http.post(
      Uri.parse(uploadUrl),
      headers: {
        'Authorization': 'Bearer $_supabaseKey',
        'Content-Type': 'image/$ext',
      },
      body: bytes,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return '$_supabaseUrl/storage/v1/object/public/$bucket/$fileName';
    }

    throw Exception('${response.statusCode}: ${response.body}');
  }
}
