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
  static const Color cardBackground = Color(0xFFE5EBF2);

  /// Soft blue used for settings card backgrounds
  static const Color settingCardBg = Color(0xFFEAF0F6);

  /// Light tinted surface (weekly-plan header, etc.)
  static const Color surface2 = Color(0xFFEFF4F8);

  /// Soft orange tint for concierge / promo cards
  static const Color softOrange = Color(0xFFF9E8C6);



  static final Color secondaryTint8 =
      const Color(0xFF5B8FB9).withOpacity(0.08);


  static final Color secondaryTint25 =
      const Color(0xFF5B8FB9).withOpacity(0.25);


  static final Color secondaryTint30 =
      const Color(0xFF5B8FB9).withOpacity(0.30);


  static final Color secondaryTint35 =
      const Color(0xFF5B8FB9).withOpacity(0.35);


  static final Color amberTint55 =
      const Color(0xFFF5A623).withOpacity(0.55);


  static final Color shadowLight = Colors.black.withOpacity(0.05);
  static final Color shadowMedium = Colors.black.withOpacity(0.08);
  static final Color ratingBadgeBg = Colors.black.withOpacity(0.75);


  static const Color text = Color(0xFF000000);
  static const Color subtext = Color(0x99000000);
  static const Color hint = Color(0x4D000000);


  static const Color textSecondary = Color(0xFF757575);


  static const Color textMuted = Color(0xFF9E9E9E);


  static const Color textDark = Color(0xFF616161);



  static const Color border = Color(0xFFE5E7EB);


  static const Color borderLight = Color(0xFFEEEEEE);


  static const Color borderMedium = Color(0xFFE0E0E0);


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

  // ── Buttons ───────────────────────────────────────────────────────────────
  /// Primary CTA button background — orange (e.g. "Continue", "Save", "Activate")
  static const Color btnPrimary = Color(0xFFF5A623);

  /// Text color on primary button
  static const Color btnPrimaryText = Color(0xFF000000);

  /// Secondary action button background — blue (e.g. "View", "Deal", "Book")
  static const Color btnSecondary = Color(0xFF5B8FB9);

  /// Text color on secondary button
  static const Color btnSecondaryText = Color(0xFFFFFFFF);

  // ── Switch / Toggle ───────────────────────────────────────────────────────
  /// Active track color (orange)
  static const Color switchActiveTrack = Color(0xFFF5A623);

  /// Thumb color for both active and inactive states (white)
  static const Color switchThumb = Color(0xFFFFFFFF);

  /// Inactive track color (grey)
  static const Color switchInactiveTrack = Color(0xFFE0E0E0);

  // ── Navigation Bar ────────────────────────────────────────────────────────
  /// Selected tab color in bottom NavigationBar
  static const Color navSelected = Color(0xFF4A90D9);

  // ── Misc ─────────────────────────────────────────────────────────────────
  /// Black card background for AI / weekly-plan cards
  static const Color planCardBg = Color(0xFF000000);

  static const Color dotActive = Color(0xFFFBAD20);
  static const Color dotInactive = Color(0xFF5682AF);
  static const Color link = Color(0xFF2B6CB0);
}
