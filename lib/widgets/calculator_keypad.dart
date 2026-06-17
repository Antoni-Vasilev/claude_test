import 'package:flutter/material.dart';

import '../calculator_engine.dart';
import '../theme/design_tokens.dart';
import 'calc_button.dart';

/// Internal description of one key in the keypad grid.
class _KeySpec {
  const _KeySpec(
    this.label, {
    this.style = CalcButtonStyle.digit,
    this.flex = 1,
    this.icon,
  });

  final String label;
  final CalcButtonStyle style;
  final int flex;
  final IconData? icon;
}

/// The calculator keypad. Emits the logical key string through [onKey].
class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({super.key, required this.onKey});

  final void Function(String) onKey;

  static const List<List<_KeySpec>> _layout = [
    [
      _KeySpec('AC', style: CalcButtonStyle.function),
      _KeySpec('+/-', style: CalcButtonStyle.function),
      _KeySpec('%', style: CalcButtonStyle.function),
      _KeySpec(CalculatorEngine.divide, style: CalcButtonStyle.operator),
    ],
    [
      _KeySpec('7'),
      _KeySpec('8'),
      _KeySpec('9'),
      _KeySpec(CalculatorEngine.times, style: CalcButtonStyle.operator),
    ],
    [
      _KeySpec('4'),
      _KeySpec('5'),
      _KeySpec('6'),
      _KeySpec('-', style: CalcButtonStyle.operator),
    ],
    [
      _KeySpec('1'),
      _KeySpec('2'),
      _KeySpec('3'),
      _KeySpec('+', style: CalcButtonStyle.operator),
    ],
    [
      _KeySpec('0', flex: 2),
      _KeySpec('.'),
      _KeySpec('=', style: CalcButtonStyle.equals),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          for (final row in _layout)
            Expanded(
              child: Row(
                children: [
                  for (final key in row)
                    Expanded(
                      flex: key.flex,
                      child: CalcButton(
                        label: key.label,
                        style: key.style,
                        icon: key.icon,
                        onTap: () => onKey(key.label),
                        // Long-pressing AC deletes the last character.
                        onLongPress:
                            key.label == 'AC' ? () => onKey('DEL') : null,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
