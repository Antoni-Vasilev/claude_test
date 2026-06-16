import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Visual styles a calculator key can take.
enum CalcButtonStyle { digit, function, operator, equals }

/// A flat, refined calculator key. Uses a solid fill, a subtle Material ripple
/// and a gentle press-scale — no gradients or colored glows.
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
      CalcButtonStyle.operator => colors.accentStart,
      CalcButtonStyle.equals => colors.accentStart,
    };

    final foreground = switch (widget.style) {
      CalcButtonStyle.digit => colors.digitForeground,
      CalcButtonStyle.function => colors.functionForeground,
      CalcButtonStyle.operator => colors.accentForeground,
      CalcButtonStyle.equals => colors.accentForeground,
    };

    return Padding(
      padding: const EdgeInsets.all(5),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onHighlightChanged: _setPressed,
              splashColor: foreground.withValues(alpha: 0.10),
              highlightColor: foreground.withValues(alpha: 0.06),
              child: Center(
                child: widget.icon != null
                    ? Icon(widget.icon, color: foreground, size: 24)
                    : Text(
                        widget.label,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 26,
                          fontWeight: isAccent
                              ? FontWeight.w500
                              : FontWeight.w400,
                          height: 1,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
