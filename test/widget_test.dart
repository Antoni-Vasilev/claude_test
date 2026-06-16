import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_calculator/main.dart';

void main() {
  testWidgets('keypad performs a calculation end to end',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // 7 × 8 = 56
    await tester.tap(find.widgetWithText(GestureDetector, '7'));
    await tester.tap(find.widgetWithText(GestureDetector, '×'));
    await tester.tap(find.widgetWithText(GestureDetector, '8'));
    await tester.pumpAndSettle();

    // Live preview shows 56 before pressing equals.
    expect(find.text('56'), findsOneWidget);

    await tester.tap(find.widgetWithText(GestureDetector, '='));
    await tester.pumpAndSettle();

    // Result still 56, and a history entry now exists ("= 56").
    expect(find.text('56'), findsOneWidget);
    expect(find.text('= 56'), findsOneWidget);
  });

  testWidgets('AC resets the display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.widgetWithText(GestureDetector, '5'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(GestureDetector, 'AC'));
    await tester.pumpAndSettle();

    // After clearing, the result falls back to 0.
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('theme toggle switches brightness', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.light_mode_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
  });
}
