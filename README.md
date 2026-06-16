# Flutter Calculator

A fully functional calculator built with Flutter and Material 3.

## Features

- Addition, subtraction, multiplication (`×`) and division (`÷`)
- Correct operator precedence and parentheses handling via a shunting-yard
  evaluator
- Decimal numbers with smart input rules (auto-prefixed leading zero, only one
  decimal point per number)
- Live result preview that updates as you type
- Percent (`%`) and sign toggle (`+/-`)
- `AC` to clear everything; long-press `AC` to delete the last character
- Continue calculating from a previous result, or start fresh with a new digit
- Friendly error messages for divide-by-zero and invalid expressions
- Haptic feedback on key presses

## Project structure

```
lib/
  main.dart                  # App entry point and UI (display + keypad)
  calculator_engine.dart     # Pure expression evaluator (UI-independent)
  calculator_controller.dart # Input/state management (ChangeNotifier)
test/
  calculator_engine_test.dart      # Unit tests for the evaluator
  calculator_controller_test.dart  # Unit tests for input/state handling
  widget_test.dart                 # Widget smoke tests
```

The calculation logic is deliberately separated from the UI so it can be unit
tested in isolation and reused.

## Getting started

Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install)
installed, then:

```bash
flutter pub get      # fetch dependencies
flutter run          # launch on a connected device or emulator
flutter test         # run the unit and widget tests
```

## How the evaluator works

`CalculatorEngine` tokenizes the on-screen expression, converts it to Reverse
Polish Notation using the shunting-yard algorithm, then evaluates the RPN
stack. Unary minus is handled as a dedicated, right-associative operator with
higher precedence than the binary operators, so expressions like `3×-2`
correctly evaluate to `-6`.
