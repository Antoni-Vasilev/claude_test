import 'package:flutter/material.dart';

import '../calculator_controller.dart';
import '../theme/app_theme.dart';

/// The upper portion of the calculator: a scrollable history list above the
/// live expression and a large, animated result.
class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key, required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CalcColors>()!;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final expression =
            controller.expression.isEmpty ? '' : controller.expression;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _History(
                  entries: controller.history,
                  colors: colors,
                  onRecall: controller.recallResult,
                ),
              ),
              const SizedBox(height: 8),
              _AutoScrollText(
                text: expression,
                style: TextStyle(
                  color: colors.displaySecondary,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.18),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _AutoScrollText(
                  key: ValueKey('${controller.result}-${controller.hasError}'),
                  text: controller.result,
                  alignment: Alignment.centerRight,
                  style: TextStyle(
                    color: controller.hasError
                        ? colors.error
                        : colors.displayPrimary,
                    fontSize: controller.hasError ? 34 : 64,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Right-aligned text that scrolls horizontally when it overflows, so long
/// numbers never get clipped.
class _AutoScrollText extends StatelessWidget {
  const _AutoScrollText({
    super.key,
    required this.text,
    required this.style,
    this.alignment = Alignment.centerRight,
  });

  final String text;
  final TextStyle style;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Align(
          alignment: alignment,
          child: Text(text, style: style, maxLines: 1),
        ),
      ),
    );
  }
}

class _History extends StatelessWidget {
  const _History({
    required this.entries,
    required this.colors,
    required this.onRecall,
  });

  final List<HistoryEntry> entries;
  final CalcColors colors;
  final void Function(String) onRecall;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black, Colors.black],
          stops: [0.0, 0.25, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.zero,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onRecall(entry.result),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.expression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.displaySecondary.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '= ${entry.result}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.displaySecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
