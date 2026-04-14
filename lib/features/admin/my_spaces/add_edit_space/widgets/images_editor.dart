import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/services/supabase_image_upload_service.dart';
import '../../../_shared/admin_ui.dart';

/// محرر قائمة صور المساحة — رفع من الجهاز أو إدخال URL
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

  static const _bucket = 'image_masahtak';
  final _imageUploadService = SupabaseImageUploadService();

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

  /// يفتح منتقي الصور من الجهاز ثم يرفعها إلى Supabase Storage
  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();

    final List<XFile>? files = await picker.pickMultiImage(imageQuality: 85);
    if (files == null || files.isEmpty) return;
    setState(() => _uploading = true);
    if (files.length > 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("حد أقصى 5 صور")));
      setState(() => _uploading = false); /// 🔥 مهم
      return;
    }

    try {
      for (int i = 0; i < files.length; i++) {
        final publicUrl = await _imageUploadService.uploadImage(
          file: files[i],
          bucket: _bucket,
        );
        widget.onAdd(publicUrl);
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
          Text(
            'Images',
            style: AdminText.body14(
              color: AdminColors.black75,
              w: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // الصور الحالية
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
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: AdminColors.black40,
                            ),
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
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
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

          // زر رفع من الجهاز
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
                  color: _uploading
                      ? AdminColors.black15
                      : AdminColors.primaryBlue,
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
                        Icon(
                          Icons.upload_rounded,
                          size: 18,
                          color: AdminColors.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pick from device',
                          style: AdminText.body14(
                            color: AdminColors.primaryBlue,
                            w: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 8),

          // إدخال URL يدوياً (خيار ثانوي)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ctrl,
                  style: AdminText.body14(color: AdminColors.text),
                  decoration: InputDecoration(
                    hintText: 'Or paste image URL…',
                    hintStyle: AdminText.body14(color: AdminColors.black40),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AdminColors.black15,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AdminColors.black15,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AdminColors.primaryBlue,
                        width: 1.5,
                      ),
                    ),
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
                      fontSize: 14,
                    ),
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
