import 'package:flutter/material.dart';

import '../calculator_controller.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';

/// The upper portion of the calculator: a scrollable history list above the
/// live expression and a large, animated result. Typography and spacing are
/// driven entirely by the design tokens.
class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key, required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CalcColors>()!;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final expression = controller.expression;
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.sm,
            AppSpacing.xxl,
            AppSpacing.md,
          ),
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
              const SizedBox(height: AppSpacing.sm),
              _AutoScrollText(
                text: expression,
                style: AppType.expression.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              AnimatedSwitcher(
                duration: AppDuration.medium,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.16),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _AutoScrollText(
                  key: ValueKey('${controller.result}-${controller.hasError}'),
                  text: controller.result,
                  style: (controller.hasError
                          ? AppType.displayError
                          : AppType.displayValue)
                      .copyWith(
                    color: controller.hasError
                        ? colors.error
                        : colors.textPrimary,
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
/// numbers are never clipped.
class _AutoScrollText extends StatelessWidget {
  const _AutoScrollText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(text, style: style, maxLines: 1),
        ),
      ),
    );
  }
}

/// A faded, scrollable list of past calculations. Each row can be tapped to
/// recall its result.
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
          stops: [0.0, 0.28, 1.0],
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
              borderRadius: BorderRadius.circular(AppRadius.sm),
              hoverColor: colors.accent.withValues(alpha: AppOverlay.hover),
              splashColor: colors.accent.withValues(alpha: AppOverlay.pressed),
              onTap: () => onRecall(entry.result),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                  horizontal: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.expression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.historyExpression
                          .copyWith(color: colors.textTertiary),
                    ),
                    Text(
                      '= ${entry.result}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.historyResult
                          .copyWith(color: colors.textSecondary),
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
