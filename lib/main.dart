import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/calculator_display.dart';
import 'widgets/calculator_keypad.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: CalculatorPage(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

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
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CalcColors>()!;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Center and cap the width so the layout also looks intentional on
            // tablets and desktop windows.
            final maxWidth =
                constraints.maxWidth > 520 ? 480.0 : constraints.maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _Header(
                      isDark: widget.isDark,
                      onToggleTheme: widget.onToggleTheme,
                      onClearHistory: _controller.clearHistory,
                    ),
                    Expanded(
                      flex: 5,
                      child: CalculatorDisplay(controller: _controller),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: colors.displaySecondary.withValues(alpha: 0.12),
                    ),
                    Expanded(
                      flex: 7,
                      child: CalculatorKeypad(onKey: _onKey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Slim top bar with the app title, a history-clear action and a theme toggle.
class _Header extends StatelessWidget {
  const _Header({
    required this.isDark,
    required this.onToggleTheme,
    required this.onClearHistory,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CalcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 0),
      child: Row(
        children: [
          Text(
            'Calculator',
            style: TextStyle(
              color: colors.displayPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Clear history',
            onPressed: onClearHistory,
            icon: Icon(Icons.history_rounded, color: colors.displaySecondary),
          ),
          IconButton(
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onPressed: onToggleTheme,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  RotationTransition(turns: animation, child: child),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                color: colors.functionForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
