import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator_controller.dart';
import 'calculator_engine.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorController _controller = CalculatorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onKey(String key) {
    _controller.input(key);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _Display(controller: _controller),
            ),
            Expanded(
              flex: 3,
              child: _Keypad(onKey: _onKey),
            ),
          ],
        ),
      ),
    );
  }
}

/// The upper area showing the running expression and the computed result.
class _Display extends StatelessWidget {
  const _Display({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final expression =
            controller.expression.isEmpty ? '0' : controller.expression;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          alignment: Alignment.bottomRight,
          child: SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    expression,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    controller.result,
                    style: TextStyle(
                      color: controller.hasError
                          ? const Color(0xFFFF6B6B)
                          : Colors.white,
                      fontSize: controller.hasError ? 36 : 56,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Describes a single calculator button.
class _Key {
  const _Key(this.label, {this.kind = _KeyKind.normal, int? flex})
      : flex = flex ?? 1;

  final String label;
  final _KeyKind kind;
  final int flex;
}

enum _KeyKind { normal, function, operator, equals }

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey});

  final void Function(String) onKey;

  static const List<List<_Key>> _layout = [
    [
      _Key('AC', kind: _KeyKind.function),
      _Key('+/-', kind: _KeyKind.function),
      _Key('%', kind: _KeyKind.function),
      _Key(CalculatorEngine.divide, kind: _KeyKind.operator),
    ],
    [
      _Key('7'),
      _Key('8'),
      _Key('9'),
      _Key(CalculatorEngine.times, kind: _KeyKind.operator),
    ],
    [
      _Key('4'),
      _Key('5'),
      _Key('6'),
      _Key('-', kind: _KeyKind.operator),
    ],
    [
      _Key('1'),
      _Key('2'),
      _Key('3'),
      _Key('+', kind: _KeyKind.operator),
    ],
    [
      _Key('0', flex: 2),
      _Key('.'),
      _Key('=', kind: _KeyKind.equals),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          for (final row in _layout)
            Expanded(
              child: Row(
                children: [
                  for (final key in row)
                    Expanded(
                      flex: key.flex,
                      child: _CalcButton(
                        label: key.label,
                        kind: key.kind,
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

class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.label,
    required this.kind,
    required this.onTap,
    this.onLongPress,
  });

  final String label;
  final _KeyKind kind;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(kind);
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: colors.foreground,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _colorsFor(_KeyKind kind) {
    switch (kind) {
      case _KeyKind.function:
        return const _ButtonColors(Color(0xFF2A2A3A), Color(0xFF6C63FF));
      case _KeyKind.operator:
        return const _ButtonColors(Color(0xFF6C63FF), Colors.white);
      case _KeyKind.equals:
        return const _ButtonColors(Color(0xFF00C896), Colors.white);
      case _KeyKind.normal:
        return const _ButtonColors(Color(0xFF1E1E2A), Colors.white);
    }
  }
}

class _ButtonColors {
  const _ButtonColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
