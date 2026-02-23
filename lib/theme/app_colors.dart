import 'package:flutter/material.dart';

class AppColors {
  // ── Primary palette ──────────────────────────────────────────────────────
  /// Main brand orange used in onboarding dots, primary buttons
  static const Color primary = Color(0xFFFBAD20);

  /// Amber orange used in CTA buttons, prices, star badges, "Best" chips
  static const Color amber = Color(0xFFF5A623);

  /// Blue used for "View" buttons, card tints, chevrons, avatar rings
  static const Color secondary = Color(0xFF5B8FB9);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);

  /// Light blue-grey surface (home cards, space-details sections)
  static const Color surface = Color(0xFFF2F5F8);

  /// Very light grey used for usage/insight cards (grey[50])
  static const Color cardSurface = Color(0xFFFAFAFA);

  /// Soft blue used for settings card backgrounds
  static const Color settingCardBg = Color(0xFFEAF0F6);

  /// Light tinted surface (weekly-plan header, etc.)
  static const Color surface2 = Color(0xFFEFF4F8);

  /// Soft orange tint for concierge / promo cards
  static const Color softOrange = Color(0xFFF9E8C6);

  // ── Secondary opacity variants (must be final, not const) ────────────────
  /// secondary @ 8% – plan-item unselected background
  static final Color secondaryTint8 =
      const Color(0xFF5B8FB9).withOpacity(0.08);

  /// secondary @ 25% – hover / subtle highlight
  static final Color secondaryTint25 =
      const Color(0xFF5B8FB9).withOpacity(0.25);

  /// secondary @ 30% – review "View" button background
  static final Color secondaryTint30 =
      const Color(0xFF5B8FB9).withOpacity(0.30);

  /// secondary @ 35% – offer flag tint
  static final Color secondaryTint35 =
      const Color(0xFF5B8FB9).withOpacity(0.35);

  /// amber @ 55% – fit-score arc fill
  static final Color amberTint55 =
      const Color(0xFFF5A623).withOpacity(0.55);

  // ── Shadow / overlay ─────────────────────────────────────────────────────
  static final Color shadowLight = Colors.black.withOpacity(0.05);
  static final Color shadowMedium = Colors.black.withOpacity(0.08);
  static final Color ratingBadgeBg = Colors.black.withOpacity(0.75);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color text = Color(0xFF000000);
  static const Color subtext = Color(0x99000000);
  static const Color hint = Color(0x4D000000);

  /// Secondary body text (grey[600] = #757575)
  static const Color textSecondary = Color(0xFF757575);

  /// Muted / caption text (grey[500] = #9E9E9E)
  static const Color textMuted = Color(0xFF9E9E9E);

  /// Slightly darker body text (grey[700] = #616161)
  static const Color textDark = Color(0xFF616161);

  // ── Borders ──────────────────────────────────────────────────────────────
  /// Default card border
  static const Color border = Color(0xFFE5E7EB);

  /// Light border (grey[200] = #EEEEEE)
  static const Color borderLight = Color(0xFFEEEEEE);

  /// Medium border for dropdowns / dividers (grey[300] = #E0E0E0)
  static const Color borderMedium = Color(0xFFE0E0E0);

  /// Dark border used for notification groups
  static const Color borderDark = Color(0xDD000000);

  // ── Input borders ────────────────────────────────────────────────────────
  /// Standard input field / card border
  static const Color inputBorder = Color(0xFFEAEAEA);

  // ── Status ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF20FB36);

  /// Red used for danger/delete actions and offer flag borders
  static const Color danger = Color(0xFFE53935);

  /// Green used for 4-star rating bars
  static const Color ratingGreen = Color(0xFF7CB342);

  // ── Booking status palette ────────────────────────────────────────────────
  static const Color approvedBg     = Color(0xFFEFF7EE);
  static const Color approvedBorder = Color(0xFFBFE2BE);
  static const Color approvedText   = Color(0xFF2E7D32);

  static const Color warningBg   = Color(0xFFFFF4E8);
  static const Color warningText = Color(0xFFB26A00);

  static const Color rejectedBg   = Color(0xFFFFEBEE);
  static const Color rejectedText = Color(0xFFC62828);

  static const Color reviewStatusBg   = Color(0xFFE9F2FF);
  static const Color reviewStatusText = Color(0xFF1F5FBF);

  static const Color neutralBadgeBg   = Color(0xFFF3F3F3);

  // ── Misc ─────────────────────────────────────────────────────────────────
  /// Black card background for AI / weekly-plan cards
  static const Color planCardBg = Color(0xFF000000);

  static const Color dotActive = Color(0xFFFBAD20);
  static const Color dotInactive = Color(0xFF5682AF);
  static const Color link = Color(0xFF2B6CB0);
}
