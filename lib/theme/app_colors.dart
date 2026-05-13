import 'package:flutter/material.dart';

/// Ceylon Explorer brand color palette
class AppColors {
  AppColors._();

  /// Teal — primary brand color for titles & buttons
  static const Color teal = Color(0xFF0D7C66);

  /// Yellow/Golden accent — logo dot
  static const Color yellowAccent = Color(0xFFE8A317);

  /// Dark text color for logo
  static const Color darkText = Color(0xFF1A1A1A);

  /// Subtitle / description gray
  static const Color subtitleGray = Color(0xFF6B6B6B);

  /// White background
  static const Color white = Color(0xFFFFFFFF);

  /// Black
  static const Color black = Color(0xFF000000);

  // ── Legacy colors (kept for backward compat) ──

  /// Deep ocean blue — primary brand color
  static const Color primary = Color(0xFF0D3B6E);

  /// Tropical gold — accent color
  static const Color accent = Color(0xFFD4A017);

  /// Rich dark navy — splash background
  static const Color background = Color(0xFF05192D);

  /// Tagline white at 60% opacity
  static const Color taglineWhite = Color(0x99FFFFFF);

  /// Soft golden glow color
  static const Color goldenGlow = Color(0x40D4A017);

  /// Logo silhouette base (dark teal-blue for the island)
  static const Color islandSilhouette = Color(0xFF0A2E54);

  /// Subtle topographic pattern line color
  static const Color topoLine = Color(0x14FFFFFF); // ~8% white
}
