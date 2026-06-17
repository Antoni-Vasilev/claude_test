import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator_controller.dart';
import 'theme/app_theme.dart';
import 'theme/design_tokens.dart';
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
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
                  height: AppLayout.hairline,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.xs,
                  ),
                  color: colors.border,
                ),
                Expanded(
                  flex: 7,
                  child: CalculatorKeypad(onKey: _onKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Slim top bar (navigation) with the app title, a history-clear action and an
/// animated theme toggle. Controls share one consistent, token-driven style.
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.sm,
            height: AppType.title.fontSize,
            decoration: BoxDecoration(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'Calculator',
            style: AppType.title.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          _NavButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.history_rounded),
            color: colors.textSecondary,
            accent: colors.accent,
            onPressed: onClearHistory,
          ),
          const SizedBox(width: AppSpacing.xs),
          _NavButton(
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            color: colors.textSecondary,
            accent: colors.accent,
            onPressed: onToggleTheme,
            icon: AnimatedSwitcher(
              duration: AppDuration.slow,
              transitionBuilder: (child, animation) =>
                  RotationTransition(turns: animation, child: child),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Consistent icon control for the header with clear hover / pressed states.
class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.accent,
    required this.onPressed,
  });

  final String tooltip;
  final Widget icon;
  final Color color;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: icon,
      style: IconButton.styleFrom(
        foregroundColor: color,
        hoverColor: accent.withValues(alpha: AppOverlay.hover),
        highlightColor: accent.withValues(alpha: AppOverlay.pressed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
