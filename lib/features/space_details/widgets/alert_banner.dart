import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../data/models/space_details_model.dart';

class AlertBanner extends StatelessWidget {
  final SpaceAlert alert;
  const AlertBanner({super.key, required this.alert});

  /// ✅ دالة: تحويل hex إلى Color
  Color _hex(String v) {
    var s = v.replaceAll('#', '').trim();
    if (s.length == 6) s = 'FF$s';
    return Color(int.parse(s, radix: 16));
  }

  /// ✅ دالة: Banner ديناميكي حسب API (لون/عنوان/تفاصيل)
  @override
  Widget build(BuildContext context) {
    final bg = _hex(alert.colorHex);
    final border = _hex(alert.borderHex);
    final text = _hex(alert.textHex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alert.title,
            style: TextStyle(fontWeight: FontWeight.w900, color: text),
          ),
          const SizedBox(height: 6),
          Text(
            alert.message,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: text.withOpacity(.9),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
