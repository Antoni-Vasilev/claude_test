import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';

/// Visual styles a calculator key can take. The hierarchy is, from least to
/// most emphasis: [digit] (neutral) → [function] (secondary) →
/// [operator] (accent-tinted) → [equals] (solid accent, the primary action).
enum CalcButtonStyle { digit, function, operator, equals }

/// A single calculator key.
///
/// Fully token-driven: colours come from [CalcColors], everything else (radius,
/// spacing, type, motion, overlays) from the design tokens. Hover, pressed and
/// the primary/secondary distinction are all expressed visually.
class CalcButton extends StatefulWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.style,
    required this.onTap,
    this.onLongPress,
    this.icon,
  });

  final String label;
  final CalcButtonStyle style;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final IconData? icon;

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CalcColors>()!;
    final isEquals = widget.style == CalcButtonStyle.equals;

    final background = switch (widget.style) {
      CalcButtonStyle.digit => colors.keyDigit,
      CalcButtonStyle.function => colors.keyFunction,
      CalcButtonStyle.operator => colors.keyOperator,
      CalcButtonStyle.equals => _pressed ? colors.accentPressed : colors.accent,
    };

    final foreground = switch (widget.style) {
      CalcButtonStyle.digit => colors.keyDigitText,
      CalcButtonStyle.function => colors.keyFunctionText,
      CalcButtonStyle.operator => colors.keyOperatorText,
      CalcButtonStyle.equals => colors.onAccent,
    };

    final textStyle = switch (widget.style) {
      CalcButtonStyle.digit => AppType.keyDigit,
      CalcButtonStyle.function => AppType.keyFunction,
      CalcButtonStyle.operator || CalcButtonStyle.equals => AppType.keyAccent,
    };

    final radius = BorderRadius.circular(AppRadius.lg);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: AnimatedScale(
        scale: _pressed ? AppLayout.pressedScale : 1.0,
        duration: AppDuration.instant,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: AppDuration.fast,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            boxShadow: colors.keyShadow,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onHighlightChanged: _setPressed,
              hoverColor: foreground.withValues(alpha: AppOverlay.hover),
              focusColor: foreground.withValues(alpha: AppOverlay.focus),
              splashColor: foreground.withValues(alpha: AppOverlay.pressed),
              highlightColor: foreground.withValues(alpha: AppOverlay.hover),
              child: Center(
                child: widget.icon != null
                    ? Icon(widget.icon, color: foreground, size: AppSpacing.xxl)
                    : Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: textStyle.copyWith(color: foreground),
                        semanticsLabel: _semanticsFor(widget.label, isEquals),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _semanticsFor(String label, bool isEquals) {
    if (isEquals) return 'equals';
    return switch (label) {
      '×' => 'multiply',
      '÷' => 'divide',
      '+/-' => 'toggle sign',
      '%' => 'percent',
      'AC' => 'all clear',
      _ => null,
    };
  }
}
