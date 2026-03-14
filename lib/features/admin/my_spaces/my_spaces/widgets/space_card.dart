import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/space_entity.dart';

class SpaceCard extends StatelessWidget {
  final SpaceEntity space;
  final VoidCallback onManage;
  final VoidCallback onHide;
  final VoidCallback onDelete;

  const SpaceCard({
    super.key,
    required this.space,
    required this.onManage,
    required this.onHide,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AdminColors.black02,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.black10, width: 1),
            ),
            alignment: Alignment.center,
            child: Text('Image', style: AdminText.body14()),
          ),
          const SizedBox(height: AdminSpace.s12),
          Text(space.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
          const SizedBox(height: AdminSpace.s4),
          Row(
            children: [
              Icon(AdminIconMapper.star(), size: 16, color: AdminColors.primaryAmber),
              const SizedBox(width: 6),
              Text(space.rating, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w500)),
              const Spacer(),
              AdminTag(
                text: (space.availability == SpaceAvailability.hidden) ? 'Hidden' : 'Available',
                tint: (space.availability == SpaceAvailability.hidden) ? AdminColors.black15 : AdminColors.primaryBlue.withOpacity(0.15),
                textColor: (space.availability == SpaceAvailability.hidden) ? AdminColors.black75 : AdminColors.primaryBlue,
              ),
            ],
          ),
          const SizedBox(height: AdminSpace.s12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onManage,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AdminColors.black15, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text('Manage', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: AdminSpace.s8),
              Expanded(
                child: InkWell(
                  onTap: onHide,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AdminColors.danger.withOpacity(0.4), width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text('Hide', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.danger, w: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: AdminSpace.s8),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AdminColors.danger.withOpacity(0.1),
                  ),
                  child: Icon(Icons.delete_outline, size: 18, color: AdminColors.danger),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on AdminSpace {
  static const s12 = 12.0;
}
