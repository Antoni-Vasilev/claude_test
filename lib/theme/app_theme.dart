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

  static const Color _seed = Color(0xFF3B6EF5);

  // A restrained, mostly-monochrome palette with a single, flat accent — no
  // bright gradients or colored glows — so the app reads as a precise tool
  // rather than a toy.
  static const CalcColors _darkColors = CalcColors(
    screenBackground: Color(0xFF0C0D10),
    panelBackground: Color(0xFF0C0D10),
    displayPrimary: Color(0xFFF7F8FA),
    displaySecondary: Color(0xFF6B6F76),
    digitButton: Color(0xFF1A1C20),
    digitForeground: Color(0xFFF2F3F5),
    functionButton: Color(0xFF26282E),
    functionForeground: Color(0xFFC9CCD2),
    accentStart: Color(0xFF3B6EF5),
    accentEnd: Color(0xFF3B6EF5),
    accentForeground: Color(0xFFFFFFFF),
    error: Color(0xFFE5484D),
    shadow: Color(0x33000000),
  );

  static const CalcColors _lightColors = CalcColors(
    screenBackground: Color(0xFFF4F5F7),
    panelBackground: Color(0xFFF4F5F7),
    displayPrimary: Color(0xFF14161A),
    displaySecondary: Color(0xFF8A8F98),
    digitButton: Color(0xFFFFFFFF),
    digitForeground: Color(0xFF14161A),
    functionButton: Color(0xFFE6E8EC),
    functionForeground: Color(0xFF40454D),
    accentStart: Color(0xFF3B6EF5),
    accentEnd: Color(0xFF3B6EF5),
    accentForeground: Color(0xFFFFFFFF),
    error: Color(0xFFD92D2D),
    shadow: Color(0x14000000),
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
