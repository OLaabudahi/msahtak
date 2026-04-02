import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/policy_section_entity.dart';

class PoliciesEditor extends StatelessWidget {
  final List<PolicySectionEntity> sections;
  final VoidCallback onAddSection;
  final void Function(String sectionId) onRemoveSection;
  final void Function(String sectionId, String title) onTitleChanged;
  final void Function(String sectionId, String bullet) onAddBullet;
  final void Function(String sectionId, int index) onRemoveBullet;
  final String? errorText;

  const PoliciesEditor({
    super.key,
    required this.sections,
    required this.onAddSection,
    required this.onRemoveSection,
    required this.onTitleChanged,
    required this.onAddBullet,
    required this.onRemoveBullet,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Policies', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700))),
              InkWell(
                onTap: onAddSection,
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

          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(errorText!, style: AdminText.label12(color: AdminColors.danger, w: FontWeight.w700)),
          ],

          const SizedBox(height: 10),

          if (sections.isEmpty)
            Text('Add sections and bullets to show in the user popup.', style: AdminText.body14(color: AdminColors.black40))
          else
            Column(
              children: sections.map((s) => _Section(
                    section: s,
                    onRemove: () => onRemoveSection(s.id),
                    onTitleChanged: (v) => onTitleChanged(s.id, v),
                    onAddBullet: () async {
                      final txt = await _askBullet(context);
                      if (txt != null && txt.trim().isNotEmpty) onAddBullet(s.id, txt.trim());
                    },
                    onRemoveBullet: (i) => onRemoveBullet(s.id, i),
                  )).toList(growable: false),
            ),
        ],
      ),
    );
  }

  static Future<String?> _askBullet(BuildContext context) async {
    String text = '';
    return showDialog<String>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add bullet', style: AdminText.body16(w: FontWeight.w700)),
        content: TextField(
          maxLines: 2,
          style: AdminText.body16(),
          onChanged: (v) => text = v,
          decoration: InputDecoration(
            hintText: 'Write bullet...',
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

class _Section extends StatelessWidget {
  final PolicySectionEntity section;
  final VoidCallback onRemove;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onAddBullet;
  final ValueChanged<int> onRemoveBullet;

  const _Section({
    required this.section,
    required this.onRemove,
    required this.onTitleChanged,
    required this.onAddBullet,
    required this.onRemoveBullet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AdminColors.black02,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.black10, width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: onTitleChanged,
                    controller: TextEditingController(text: section.title)..selection = TextSelection.collapsed(offset: section.title.length),
                    style: AdminText.body16(w: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Section title',
                      hintStyle: AdminText.body16(color: AdminColors.black40),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(AdminIconMapper.xCircle(), size: 18, color: AdminColors.danger),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: onAddBullet,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AdminColors.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AdminColors.black15, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(AdminIconMapper.plus(), size: 16, color: AdminColors.primaryBlue),
                      const SizedBox(width: 6),
                      Text('Add bullet', style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            if (section.bullets.isEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('No bullets yet', style: AdminText.body14(color: AdminColors.black40)),
              )
            else
              Column(
                children: List.generate(section.bullets.length, (i) {
                  final b = section.bullets[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Text('• '),
                        Expanded(child: Text(b, maxLines: 2, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w600))),
                        InkWell(
                          onTap: () => onRemoveBullet(i),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(AdminIconMapper.hide(), size: 18, color: AdminColors.black40),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}


