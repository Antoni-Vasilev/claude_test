import 'package:flutter/material.dart';

import 'design_tokens.dart';

/// Semantic colour tokens for the calculator.
///
/// Stored as a [ThemeExtension] so both the light and dark variants are
/// resolved through `Theme.of(context)` and animate smoothly when the theme is
/// toggled. The palette is deliberately minimal: neutral surfaces plus a single
/// vivid orange accent (with one error red).
@immutable
class CalcColors extends ThemeExtension<CalcColors> {
  const CalcColors({
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.keyDigit,
    required this.keyDigitText,
    required this.keyFunction,
    required this.keyFunctionText,
    required this.keyOperator,
    required this.keyOperatorText,
    required this.accent,
    required this.accentPressed,
    required this.onAccent,
    required this.error,
    required this.shadow,
  });

  // Surfaces
  final Color background;
  final Color surface;
  final Color border;

  // Text hierarchy
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  // Digit keys (neutral, primary surface)
  final Color keyDigit;
  final Color keyDigitText;

  // Function keys (AC, +/-, % — secondary actions)
  final Color keyFunction;
  final Color keyFunctionText;

  // Operator keys (accent-tinted secondary)
  final Color keyOperator;
  final Color keyOperatorText;

  // Accent / primary action (equals)
  final Color accent;
  final Color accentPressed;
  final Color onAccent;

  // Feedback
  final Color error;

  // Effects
  final Color shadow;

  /// Soft shadow used to lift keys off the background.
  List<BoxShadow> get keyShadow => [
        BoxShadow(
          color: shadow,
          blurRadius: AppElevation.keyBlur,
          offset: AppElevation.keyOffset,
        ),
      ];

  /// Slightly larger shadow for raised panels (e.g. the history card).
  List<BoxShadow> get panelShadow => [
        BoxShadow(
          color: shadow,
          blurRadius: AppElevation.panelBlur,
          offset: AppElevation.panelOffset,
        ),
      ];

  @override
  CalcColors copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? keyDigit,
    Color? keyDigitText,
    Color? keyFunction,
    Color? keyFunctionText,
    Color? keyOperator,
    Color? keyOperatorText,
    Color? accent,
    Color? accentPressed,
    Color? onAccent,
    Color? error,
    Color? shadow,
  }) {
    return CalcColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      keyDigit: keyDigit ?? this.keyDigit,
      keyDigitText: keyDigitText ?? this.keyDigitText,
      keyFunction: keyFunction ?? this.keyFunction,
      keyFunctionText: keyFunctionText ?? this.keyFunctionText,
      keyOperator: keyOperator ?? this.keyOperator,
      keyOperatorText: keyOperatorText ?? this.keyOperatorText,
      accent: accent ?? this.accent,
      accentPressed: accentPressed ?? this.accentPressed,
      onAccent: onAccent ?? this.onAccent,
      error: error ?? this.error,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  CalcColors lerp(ThemeExtension<CalcColors>? other, double t) {
    if (other is! CalcColors) return this;
    return CalcColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      keyDigit: Color.lerp(keyDigit, other.keyDigit, t)!,
      keyDigitText: Color.lerp(keyDigitText, other.keyDigitText, t)!,
      keyFunction: Color.lerp(keyFunction, other.keyFunction, t)!,
      keyFunctionText: Color.lerp(keyFunctionText, other.keyFunctionText, t)!,
      keyOperator: Color.lerp(keyOperator, other.keyOperator, t)!,
      keyOperatorText: Color.lerp(keyOperatorText, other.keyOperatorText, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentPressed: Color.lerp(accentPressed, other.accentPressed, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      error: Color.lerp(error, other.error, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Builds the light and dark [ThemeData] used by the app.
class AppTheme {
  const AppTheme._();

  /// The single vivid accent used across the app.
  static const Color _accent = Color(0xFFFF6A2C);
  static const Color _accentPressed = Color(0xFFE85A1E);

  static const CalcColors _darkColors = CalcColors(
    background: Color(0xFF0E0F12),
    surface: Color(0xFF181A1F),
    border: Color(0xFF23262C),
    textPrimary: Color(0xFFF6F7F9),
    textSecondary: Color(0xFF9AA0A8),
    textTertiary: Color(0xFF646A72),
    keyDigit: Color(0xFF1A1C21),
    keyDigitText: Color(0xFFF6F7F9),
    keyFunction: Color(0xFF262A31),
    keyFunctionText: Color(0xFFC7CCD3),
    keyOperator: Color(0xFF2C2017),
    keyOperatorText: Color(0xFFFF8A4C),
    accent: _accent,
    accentPressed: _accentPressed,
    onAccent: Color(0xFFFFFFFF),
    error: Color(0xFFFF5C5C),
    shadow: Color(0x59000000),
  );

  static const CalcColors _lightColors = CalcColors(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF4F5F7),
    border: Color(0xFFECEDF0),
    textPrimary: Color(0xFF16181C),
    textSecondary: Color(0xFF7A808A),
    textTertiary: Color(0xFFA6ABB3),
    keyDigit: Color(0xFFF4F5F7),
    keyDigitText: Color(0xFF16181C),
    keyFunction: Color(0xFFE9EBEF),
    keyFunctionText: Color(0xFF454B54),
    keyOperator: Color(0xFFFFEEE4),
    keyOperatorText: Color(0xFFF25A19),
    accent: _accent,
    accentPressed: _accentPressed,
    onAccent: Color(0xFFFFFFFF),
    error: Color(0xFFE5352B),
    shadow: Color(0x14000000),
  );

  static ThemeData dark() => _build(Brightness.dark, _darkColors);
  static ThemeData light() => _build(Brightness.light, _lightColors);

  static ThemeData _build(Brightness brightness, CalcColors colors) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accent,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.background,
      splashFactory: InkSparkle.splashFactory,
    );
    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
