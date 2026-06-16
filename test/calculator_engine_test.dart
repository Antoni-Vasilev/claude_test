import 'package:flutter_calculator/calculator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = CalculatorEngine();

  group('basic arithmetic', () {
    test('addition', () {
      expect(engine.evaluate('2+3'), 5);
    });

    test('subtraction', () {
      expect(engine.evaluate('10-4'), 6);
    });

    test('multiplication with display symbol', () {
      expect(engine.evaluate('6×7'), 42);
    });

    test('division with display symbol', () {
      expect(engine.evaluate('20÷5'), 4);
    });
  });

  group('operator precedence', () {
    test('multiplication before addition', () {
      expect(engine.evaluate('2+3×4'), 14);
    });

    test('division before subtraction', () {
      expect(engine.evaluate('100-20÷4'), 95);
    });

    test('parentheses override precedence', () {
      expect(engine.evaluate('(2+3)×4'), 20);
    });

    test('nested parentheses', () {
      expect(engine.evaluate('((1+2)×(3+4))'), 21);
    });
  });

  group('decimals', () {
    test('decimal addition', () {
      expect(engine.evaluate('0.1+0.2'), closeTo(0.3, 1e-9));
    });

    test('decimal multiplication', () {
      expect(engine.evaluate('1.5×2'), 3);
    });
  });

  group('unary signs', () {
    test('leading minus', () {
      expect(engine.evaluate('-5+3'), -2);
    });

    test('minus after operator', () {
      expect(engine.evaluate('3×-2'), -6);
    });

    test('leading plus', () {
      expect(engine.evaluate('+4'), 4);
    });
  });

  group('percent', () {
    test('standalone percent', () {
      expect(engine.evaluate('50%'), 0.5);
    });

    test('percent in expression', () {
      expect(engine.evaluate('200×10%'), 20);
    });
  });

  group('errors', () {
    test('division by zero throws', () {
      expect(() => engine.evaluate('5÷0'), throwsA(isA<DivideByZeroException>()));
    });

    test('empty parentheses throw', () {
      expect(() => engine.evaluate('()'), throwsA(isA<FormatException>()));
    });

    test('mismatched parentheses throw', () {
      expect(() => engine.evaluate('(2+3'), throwsA(isA<FormatException>()));
    });

    test('trailing operator throws', () {
      expect(() => engine.evaluate('2+'), throwsA(isA<FormatException>()));
    });

    test('double decimal throws', () {
      expect(() => engine.evaluate('1.2.3'), throwsA(isA<FormatException>()));
    });
  });

  group('formatting', () {
    test('integers drop trailing zero', () {
      expect(engine.evaluateToString('4÷2'), '2');
    });

    test('decimals keep precision without dangling zeros', () {
      expect(engine.evaluateToString('1÷4'), '0.25');
    });

    test('formatNumber strips trailing zeros', () {
      expect(CalculatorEngine.formatNumber(3.5000), '3.5');
      expect(CalculatorEngine.formatNumber(7.0), '7');
    });
  });
}
