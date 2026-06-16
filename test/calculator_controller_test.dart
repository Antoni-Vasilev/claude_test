import 'package:flutter_calculator/calculator_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculatorController controller;

  setUp(() {
    controller = CalculatorController();
  });

  void type(String keys) {
    for (final key in keys.split('')) {
      controller.input(key);
    }
  }

  test('starts at zero', () {
    expect(controller.expression, '');
    expect(controller.result, '0');
  });

  test('builds an expression and previews the result', () {
    type('12+3');
    expect(controller.expression, '12+3');
    expect(controller.result, '15');
  });

  test('equals finalizes the result', () {
    type('7×6');
    controller.input('=');
    expect(controller.result, '42');
  });

  test('continuing after equals with operator chains from result', () {
    type('4+4');
    controller.input('=');
    controller.input('+');
    controller.input('2');
    expect(controller.expression, '8+2');
    expect(controller.result, '10');
  });

  test('typing a digit after equals starts fresh', () {
    type('4+4');
    controller.input('=');
    controller.input('9');
    expect(controller.expression, '9');
  });

  test('AC clears everything', () {
    type('123+456');
    controller.input('AC');
    expect(controller.expression, '');
    expect(controller.result, '0');
  });

  test('DEL removes the last character', () {
    type('123');
    controller.input('DEL');
    expect(controller.expression, '12');
  });

  test('consecutive operators replace each other', () {
    type('5+');
    controller.input('-');
    expect(controller.expression, '5-');
  });

  test('decimal point auto-prefixes a zero', () {
    controller.input('.');
    expect(controller.expression, '0.');
  });

  test('cannot add two decimals to one number', () {
    type('1.5');
    controller.input('.');
    expect(controller.expression, '1.5');
  });

  test('toggle sign negates the current number', () {
    type('5');
    controller.input('+/-');
    expect(controller.expression, '-5');
    controller.input('+/-');
    expect(controller.expression, '5');
  });

  test('percent appends and previews', () {
    type('50');
    controller.input('%');
    expect(controller.expression, '50%');
    expect(controller.result, '0.5');
  });

  test('division by zero shows an error', () {
    type('5÷0');
    controller.input('=');
    expect(controller.hasError, isTrue);
    expect(controller.result, "Can't divide by zero");
  });

  test('a key after an error clears it', () {
    type('5÷0');
    controller.input('=');
    controller.input('7');
    expect(controller.hasError, isFalse);
    expect(controller.expression, '7');
  });
}
