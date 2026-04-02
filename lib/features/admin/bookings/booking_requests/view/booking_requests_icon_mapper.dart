import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../domain/entities/admin_icon.dart';

class BookingRequestsIconMapper {
  static IconData toIconData(AdminIcon icon) {
    switch (icon) {
      case AdminIcon.clock:
        return LucideIcons.clock;
      case AdminIcon.checkCircle:
        return LucideIcons.circleCheck;
      case AdminIcon.xCircle:
        return LucideIcons.circleX;
    }
  }
}


