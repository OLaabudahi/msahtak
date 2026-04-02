import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../domain/entities/admin_icon.dart';

class BookingDetailsIconMapper {
  static IconData toIconData(AdminIcon icon) {
    switch (icon) {
      case AdminIcon.arrowLeft:
        return LucideIcons.arrowLeft;
      case AdminIcon.mapPin:
        return LucideIcons.mapPin;
      case AdminIcon.clock:
        return LucideIcons.clock;
      case AdminIcon.calendar:
        return LucideIcons.calendar;
      case AdminIcon.user:
        return LucideIcons.user;
      case AdminIcon.phone:
        return LucideIcons.phone;
      case AdminIcon.mail:
        return LucideIcons.mail;
    }
  }
}


