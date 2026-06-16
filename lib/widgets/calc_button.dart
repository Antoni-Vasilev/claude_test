import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Visual styles a calculator key can take.
enum CalcButtonStyle { digit, function, operator, equals }

/// A tactile, animated calculator key. Scales down while pressed and renders a
/// gradient fill for accent (operator/equals) keys.
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
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CalcColors>()!;
    final isAccent = widget.style == CalcButtonStyle.operator ||
        widget.style == CalcButtonStyle.equals;

    final background = switch (widget.style) {
      CalcButtonStyle.digit => colors.digitButton,
      CalcButtonStyle.function => colors.functionButton,
      CalcButtonStyle.operator => null,
      CalcButtonStyle.equals => null,
    };

    final foreground = switch (widget.style) {
      CalcButtonStyle.digit => colors.digitForeground,
      CalcButtonStyle.function => colors.functionForeground,
      CalcButtonStyle.operator => colors.accentForeground,
      CalcButtonStyle.equals => colors.accentForeground,
    };

    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _pressed ? 0.93 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: background,
              gradient: isAccent ? colors.accentGradient : null,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: isAccent
                      ? colors.accentEnd.withValues(alpha: _pressed ? 0.15 : 0.35)
                      : colors.shadow,
                  blurRadius: _pressed ? 4 : 14,
                  offset: Offset(0, _pressed ? 2 : 6),
                ),
              ],
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(widget.icon, color: foreground, size: 26)
                  : Text(
                      widget.label,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
