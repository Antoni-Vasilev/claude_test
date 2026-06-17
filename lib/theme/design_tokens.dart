import 'package:flutter/widgets.dart';

/// Centralised design tokens for the whole app.
///
/// Every component pulls its spacing, radii, durations, type scale and overlay
/// values from here so there are no magic numbers scattered across widgets and
/// the visual language can be tuned in one place. Colours and shadows are
/// theme-dependent and therefore live on the `CalcColors` theme extension.

/// 4-point spacing scale.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

/// Corner radii. Keys and panels use these so geometry stays consistent.
abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 28;
  static const double pill = 999;
}

/// Animation durations.
abstract final class AppDuration {
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration medium = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 300);
}

/// Opacity values for interactive overlay states (hover / focus / pressed).
abstract final class AppOverlay {
  static const double hover = 0.06;
  static const double focus = 0.10;
  static const double pressed = 0.14;
}

/// Numeric elevation specs. The actual shadow colour comes from the theme so
/// shadows read correctly in both light and dark mode.
abstract final class AppElevation {
  static const double keyBlur = 10;
  static const Offset keyOffset = Offset(0, 3);
  static const double panelBlur = 20;
  static const Offset panelOffset = Offset(0, 6);
}

/// Layout constants.
abstract final class AppLayout {
  /// Caps the calculator width so it stays usable on tablets and desktop.
  static const double maxContentWidth = 460;

  /// The pressed-state scale applied to keys.
  static const double pressedScale = 0.96;

  /// Thickness of hairline dividers / fine borders.
  static const double hairline = 1;
}

/// Type scale. Styles are intentionally colour-less; each component applies the
/// appropriate colour token from `CalcColors`, keeping a single source of truth
/// for both the type ramp and the palette.
abstract final class AppType {
  /// The big primary result value — large and bold.
  static const TextStyle displayValue = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.5,
    height: 1.0,
  );

  /// Error message shown in place of the value.
  static const TextStyle displayError = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.1,
  );

  /// The live expression above the result — smaller and lighter.
  static const TextStyle expression = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.1,
  );

  /// History row: the original expression (label).
  static const TextStyle historyExpression = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.2,
  );

  /// History row: the computed result (value).
  static const TextStyle historyResult = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
    height: 1.2,
  );

  /// Digit and dot keys.
  static const TextStyle keyDigit = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  /// Operator and equals keys — slightly heavier to signal the accent group.
  static const TextStyle keyAccent = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  /// Function keys (AC, +/-, %).
  static const TextStyle keyFunction = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  /// App-bar title.
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.0,
  );
}
