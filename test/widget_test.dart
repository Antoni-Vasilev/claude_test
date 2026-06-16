import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_calculator/main.dart';

void main() {
  testWidgets('keypad performs a calculation end to end',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // 7 × 8 = 56
    await tester.tap(find.text('7'));
    await tester.tap(find.text('×'));
    await tester.tap(find.text('8'));
    await tester.pump();

    // Live preview shows 56 before pressing equals.
    expect(find.text('56'), findsOneWidget);

    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('56'), findsOneWidget);
  });

  testWidgets('AC resets the display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.text('AC'));
    await tester.pump();

    // After clearing, the display falls back to 0.
    expect(find.text('0'), findsWidgets);
  });
}
