import 'package:flutter/material.dart';

/// Calculator-specific colors that live alongside the Material [ThemeData] so
/// both light and dark variants can be looked up via `Theme.of(context)`.
@immutable
class CalcColors extends ThemeExtension<CalcColors> {
  const CalcColors({
    required this.screenBackground,
    required this.panelBackground,
    required this.displayPrimary,
    required this.displaySecondary,
    required this.digitButton,
    required this.digitForeground,
    required this.functionButton,
    required this.functionForeground,
    required this.accentStart,
    required this.accentEnd,
    required this.accentForeground,
    required this.error,
    required this.shadow,
  });

  final Color screenBackground;
  final Color panelBackground;
  final Color displayPrimary;
  final Color displaySecondary;
  final Color digitButton;
  final Color digitForeground;
  final Color functionButton;
  final Color functionForeground;
  final Color accentStart;
  final Color accentEnd;
  final Color accentForeground;
  final Color error;
  final Color shadow;

  /// Convenience gradient used for the operator and equals keys.
  LinearGradient get accentGradient => LinearGradient(
        colors: [accentStart, accentEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  CalcColors copyWith({
    Color? screenBackground,
    Color? panelBackground,
    Color? displayPrimary,
    Color? displaySecondary,
    Color? digitButton,
    Color? digitForeground,
    Color? functionButton,
    Color? functionForeground,
    Color? accentStart,
    Color? accentEnd,
    Color? accentForeground,
    Color? error,
    Color? shadow,
  }) {
    return CalcColors(
      screenBackground: screenBackground ?? this.screenBackground,
      panelBackground: panelBackground ?? this.panelBackground,
      displayPrimary: displayPrimary ?? this.displayPrimary,
      displaySecondary: displaySecondary ?? this.displaySecondary,
      digitButton: digitButton ?? this.digitButton,
      digitForeground: digitForeground ?? this.digitForeground,
      functionButton: functionButton ?? this.functionButton,
      functionForeground: functionForeground ?? this.functionForeground,
      accentStart: accentStart ?? this.accentStart,
      accentEnd: accentEnd ?? this.accentEnd,
      accentForeground: accentForeground ?? this.accentForeground,
      error: error ?? this.error,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  CalcColors lerp(ThemeExtension<CalcColors>? other, double t) {
    if (other is! CalcColors) return this;
    return CalcColors(
      screenBackground: Color.lerp(screenBackground, other.screenBackground, t)!,
      panelBackground: Color.lerp(panelBackground, other.panelBackground, t)!,
      displayPrimary: Color.lerp(displayPrimary, other.displayPrimary, t)!,
      displaySecondary:
          Color.lerp(displaySecondary, other.displaySecondary, t)!,
      digitButton: Color.lerp(digitButton, other.digitButton, t)!,
      digitForeground: Color.lerp(digitForeground, other.digitForeground, t)!,
      functionButton: Color.lerp(functionButton, other.functionButton, t)!,
      functionForeground:
          Color.lerp(functionForeground, other.functionForeground, t)!,
      accentStart: Color.lerp(accentStart, other.accentStart, t)!,
      accentEnd: Color.lerp(accentEnd, other.accentEnd, t)!,
      accentForeground:
          Color.lerp(accentForeground, other.accentForeground, t)!,
      error: Color.lerp(error, other.error, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Builds the light and dark [ThemeData] used by the app.
class AppTheme {
  const AppTheme._();

  static const Color _seed = Color(0xFF6C5CE7);

  static const CalcColors _darkColors = CalcColors(
    screenBackground: Color(0xFF0E0E14),
    panelBackground: Color(0xFF16161F),
    displayPrimary: Color(0xFFFFFFFF),
    displaySecondary: Color(0xFF8A8A9B),
    digitButton: Color(0xFF20202C),
    digitForeground: Color(0xFFF4F4F8),
    functionButton: Color(0xFF2C2C3A),
    functionForeground: Color(0xFFB9A7FF),
    accentStart: Color(0xFF7B6CF6),
    accentEnd: Color(0xFF5A4BD6),
    accentForeground: Color(0xFFFFFFFF),
    error: Color(0xFFFF6B6B),
    shadow: Color(0x66000000),
  );

  static const CalcColors _lightColors = CalcColors(
    screenBackground: Color(0xFFF1F2F8),
    panelBackground: Color(0xFFFFFFFF),
    displayPrimary: Color(0xFF1A1A2E),
    displaySecondary: Color(0xFF9A9AAE),
    digitButton: Color(0xFFFFFFFF),
    digitForeground: Color(0xFF1A1A2E),
    functionButton: Color(0xFFE7E7F2),
    functionForeground: Color(0xFF6C5CE7),
    accentStart: Color(0xFF7B6CF6),
    accentEnd: Color(0xFF5A4BD6),
    accentForeground: Color(0xFFFFFFFF),
    error: Color(0xFFE53E3E),
    shadow: Color(0x1A1A1A40),
  );

  static ThemeData dark() => _build(Brightness.dark, _darkColors);
  static ThemeData light() => _build(Brightness.light, _lightColors);

  static ThemeData _build(Brightness brightness, CalcColors colors) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.screenBackground,
    );
    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
