import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/amenity_entity.dart';

class AmenitiesEditor extends StatelessWidget {
  final List<AmenityEntity> amenities;
  final bool loading;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onAdd;

  const AmenitiesEditor({
    super.key,
    required this.amenities,
    required this.loading,
    required this.onToggle,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Amenities', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700))),
              InkWell(
                onTap: () async {
                  final name = await _askAmenity(context);
                  if (name != null && name.trim().isNotEmpty) onAdd(name.trim());
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AdminColors.primaryBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(AdminIconMapper.plus(), size: 16, color: AdminColors.primaryBlue),
                      const SizedBox(width: 6),
                      Text('Add', style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (loading)
            const SizedBox(height: 64, child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))))
          else if (amenities.isEmpty)
            Text('No amenities yet', style: AdminText.body14(color: AdminColors.black40))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: amenities.map((a) {
                final bg = a.selected ? AdminColors.primaryBlue.withOpacity(0.15) : Colors.transparent;
                final br = a.selected ? AdminColors.primaryBlue.withOpacity(0.15) : AdminColors.black15;
                final fg = a.selected ? AdminColors.primaryBlue : AdminColors.black75;

                return InkWell(
                  onTap: () => onToggle(a.id),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: br, width: 1),
                    ),
                    child: Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: fg, w: FontWeight.w700)),
                  ),
                );
              }).toList(growable: false),
            ),
        ],
      ),
    );
  }

  static Future<String?> _askAmenity(BuildContext context) async {
    String text = '';
    return showDialog<String>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Amenity', style: AdminText.body16(w: FontWeight.w700)),
        content: TextField(
          style: AdminText.body16(),
          onChanged: (v) => text = v,
          decoration: InputDecoration(
            hintText: 'Amenity name...',
            hintStyle: AdminText.body16(color: AdminColors.black40),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: Text('Cancel', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700))),
          TextButton(onPressed: () => Navigator.of(ctx).pop(text), child: Text('Add', style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700))),
        ],
      ),
    );
  }
}
