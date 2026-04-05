import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminColors {
  static const bg = Color(0xFFFFFFFF);
  static const text = Color(0xFF000000);

  static const primaryBlue = Color(0xFF5682AF);
  static const primaryAmber = Color(0xFFFBAD20);
  static const danger = Color(0xFFFB2020);
  static const success = Color(0xFF20FB36);

  static const black75 = Color(0xBF000000);
  static const black40 = Color(0x66000000);
  static const black15 = Color(0x26000000);
  static const black10 = Color(0x1A000000);
  static const black02 = Color(0x05000000);

  static Color withOpacity(Color c, double opacity) => c.withOpacity(opacity);
}

class AdminRadii {
  static const r6 = Radius.circular(6);
  static const r8 = Radius.circular(8);
  static const r10 = Radius.circular(10);
  static const r12 = Radius.circular(12);
  static const r24 = Radius.circular(24);
}

class AdminSpace {
  static const s32 = 32.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s8 = 8.0;
  static const s4 = 4.0;
}

class AdminText {
  static TextStyle h1() => const TextStyle(
        fontSize: 28,
        height: 1.5,
        fontWeight: FontWeight.w600,
        color: AdminColors.text,
      );

  static TextStyle h2() => const TextStyle(
        fontSize: 18,
        height: 1.5,
        fontWeight: FontWeight.w600,
        color: AdminColors.text,
      );

  static TextStyle body14({Color color = AdminColors.black40, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontSize: 14, height: 1.5, fontWeight: w, color: color);

  static TextStyle body16({Color color = AdminColors.text, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontSize: 16, height: 1.5, fontWeight: w, color: color);

  static TextStyle label12({Color color = AdminColors.black40, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontSize: 12, height: 1.5, fontWeight: w, color: color);
}

class AdminIconMapper {
  static IconData back() => LucideIcons.arrowLeft;
  static IconData home() => LucideIcons.layoutDashboard;
  static IconData bookings() => LucideIcons.calendarCheck2;
  static IconData users() => LucideIcons.users;
  static IconData analytics() => LucideIcons.chartLine;

  static IconData settings() => LucideIcons.settings; 

  static IconData plus() => LucideIcons.plus;
  static IconData chevronDown() => LucideIcons.chevronDown;
  static IconData star() => LucideIcons.star;
  static IconData eye() => LucideIcons.eye;
  static IconData edit() => LucideIcons.pencil;
  static IconData hide() => LucideIcons.eyeOff;
  static IconData upload() => LucideIcons.upload;
  static IconData search() => LucideIcons.search;
  static IconData filter() => LucideIcons.listFilter;
  static IconData clock() => LucideIcons.clock;
  static IconData checkCircle() => LucideIcons.circleCheck;
  static IconData xCircle() => LucideIcons.circleX;
  static IconData mapPin() => LucideIcons.mapPin;
  static IconData mail() => LucideIcons.mail;
  static IconData phone() => LucideIcons.phone;
  static IconData note() => LucideIcons.stickyNote;
  static IconData export() => LucideIcons.download;
  static IconData logout() => LucideIcons.logOut; 
}

class AdminAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const AdminAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AdminSpace.s16, AdminSpace.s32, AdminSpace.s16, AdminSpace.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null) ...[
            InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(AdminIconMapper.back(), size: 24, color: AdminColors.text),
              ),
            ),
            const SizedBox(width: AdminSpace.s8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.h1()),
                if (subtitle != null) ...[
                  const SizedBox(height: AdminSpace.s4),
                  Text(subtitle!, maxLines: 2, overflow: TextOverflow.ellipsis, style: AdminText.body14()),
                ],
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final bool outline;

  const AdminButton.filled({
    super.key,
    required this.label,
    required this.onTap,
    required this.bg,
    this.fg = Colors.white,
  }) : outline = false;

  const AdminButton.outline({
    super.key,
    required this.label,
    required this.onTap,
    required this.bg,
    required this.fg,
  }) : outline = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: outline ? AdminColors.bg : bg,
          borderRadius: BorderRadius.circular(12),
          border: outline ? Border.all(color: bg, width: 1) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AdminText.body16(color: fg, w: FontWeight.w600),
        ),
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AdminColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.black15, width: 1),
      ),
      child: child,
    );
  }
}

class AdminTag extends StatelessWidget {
  final String text;
  final Color tint;
  final Color textColor;

  const AdminTag({
    super.key,
    required this.text,
    required this.tint,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AdminText.label12(color: textColor, w: FontWeight.w500),
      ),
    );
  }
}


