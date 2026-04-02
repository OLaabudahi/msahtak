import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../_shared/admin_ui.dart';

/// ظ…ط­ط±ط± ظ‚ط§ط¦ظ…ط© طµظˆط± ط§ظ„ظ…ط³ط§ط­ط© â€” ط±ظپط¹ ظ…ظ† ط§ظ„ط¬ظ‡ط§ط² ط£ظˆ ط¥ط¯ط®ط§ظ„ URL
class ImagesEditor extends StatefulWidget {
  final List<String> images;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  const ImagesEditor({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<ImagesEditor> createState() => _ImagesEditorState();
}

class _ImagesEditorState extends State<ImagesEditor> {
  final _ctrl = TextEditingController();
  bool _uploading = false;

  static const _supabaseUrl = 'https://fbepuxcsyrerfhzpqvmy.supabase.co';
  static const _supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZiZXB1eGNzeXJlcmZoenBxdm15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzg0MjcsImV4cCI6MjA4ODcxNDQyN30.mNJOsm7RGIaX9OMw1c5R-3O9QV9bixoGc0rZKKecOLk';
  static const _bucket = 'image_masahtak';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _addUrl() {
    final url = _ctrl.text.trim();
    if (url.isEmpty) return;
    widget.onAdd(url);
    _ctrl.clear();
  }

  /// ظٹظپطھط­ ظ…ظ†طھظ‚ظٹ ط§ظ„طµظˆط± ظ…ظ† ط§ظ„ط¬ظ‡ط§ط² ط«ظ… ظٹط±ظپط¹ظ‡ط§ ط¥ظ„ظ‰ Supabase Storage
  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;

    setState(() => _uploading = true);
    try {
      final bytes = await file.readAsBytes();
      final ext = file.name.contains('.') ? file.name.split('.').last.toLowerCase() : 'jpg';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final uploadUrl = '$_supabaseUrl/storage/v1/object/$_bucket/$fileName';

      final response = await http.post(
        Uri.parse(uploadUrl),
        headers: {
          'Authorization': 'Bearer $_supabaseKey',
          'Content-Type': 'image/$ext',
        },
        body: bytes,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final publicUrl = '$_supabaseUrl/storage/v1/object/public/$_bucket/$fileName';
        widget.onAdd(publicUrl);
      } else {
        throw Exception('${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AdminColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Images',
              style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
          const SizedBox(height: 8),

          // ط§ظ„طµظˆط± ط§ظ„ط­ط§ظ„ظٹط©
          if (widget.images.isNotEmpty) ...[
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final url = widget.images[i];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 90,
                            color: AdminColors.black15,
                            child: const Icon(Icons.broken_image_outlined,
                                color: AdminColors.black40),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => widget.onRemove(i),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(3),
                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],

          // ط²ط± ط±ظپط¹ ظ…ظ† ط§ظ„ط¬ظ‡ط§ط²
          InkWell(
            onTap: _uploading ? null : _pickAndUpload,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: _uploading
                    ? AdminColors.black10
                    : AdminColors.primaryBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _uploading ? AdminColors.black15 : AdminColors.primaryBlue,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: _uploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload_rounded, size: 18, color: AdminColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Pick from device',
                          style: AdminText.body14(
                              color: AdminColors.primaryBlue, w: FontWeight.w700),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 8),

          // ط¥ط¯ط®ط§ظ„ URL ظٹط¯ظˆظٹط§ظ‹ (ط®ظٹط§ط± ط«ط§ظ†ظˆظٹ)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ctrl,
                  style: AdminText.body14(color: AdminColors.text),
                  decoration: InputDecoration(
                    hintText: 'Or paste image URLâ€¦',
                    hintStyle: AdminText.body14(color: AdminColors.black40),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AdminColors.black15, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AdminColors.black15, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AdminColors.primaryBlue, width: 1.5)),
                  ),
                  onFieldSubmitted: (_) => _addUrl(),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _addUrl,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AdminColors.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


