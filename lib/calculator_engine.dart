/// Pure calculation logic for the calculator, kept independent of any UI so it
/// can be unit-tested in isolation.
///
/// The engine evaluates infix arithmetic expressions made of the tokens that
/// the on-screen keypad can produce: the digits, a decimal point, the four
/// binary operators (`+`, `-`, `×`, `÷`), parentheses and a unary percent
/// sign. Operator precedence and associativity are honoured via the
/// shunting-yard algorithm.
class CalculatorEngine {
  const CalculatorEngine();

  /// Multiplication symbol shown to the user.
  static const String times = '×';

  /// Division symbol shown to the user.
  static const String divide = '÷';

  /// Evaluates [expression] and returns the numeric result.
  ///
  /// Throws a [FormatException] for malformed input and a
  /// [DivideByZeroException] when a division by zero is attempted.
  double evaluate(String expression) {
    final tokens = _tokenize(expression);
    final rpn = _toReversePolish(tokens);
    return _evaluateRpn(rpn);
  }

  /// Like [evaluate] but returns a trimmed, display-friendly string instead of
  /// a raw double (e.g. `4` rather than `4.0`).
  String evaluateToString(String expression) {
    return formatNumber(evaluate(expression));
  }

  /// Formats [value] for display: integers lose their trailing `.0`, other
  /// numbers keep up to ten significant decimals without dangling zeros.
  static String formatNumber(double value) {
    if (value.isNaN) {
      throw const FormatException('Result is not a number');
    }
    if (value.isInfinite) {
      throw const DivideByZeroException();
    }
    if (value == value.truncateToDouble() && value.abs() < 1e16) {
      return value.toInt().toString();
    }
    // Trim trailing zeros while keeping a sensible precision.
    var result = value.toStringAsFixed(10);
    result = result.replaceFirst(RegExp(r'0+$'), '');
    result = result.replaceFirst(RegExp(r'\.$'), '');
    return result;
  }

  // --- Internal helpers -----------------------------------------------------

  List<_Token> _tokenize(String expression) {
    final tokens = <_Token>[];
    var i = 0;

    while (i < expression.length) {
      final char = expression[i];

      if (char == ' ') {
        i++;
        continue;
      }

      if (_isDigit(char) || char == '.') {
        final buffer = StringBuffer();
        var dotSeen = false;
        while (i < expression.length &&
            (_isDigit(expression[i]) || expression[i] == '.')) {
          if (expression[i] == '.') {
            if (dotSeen) {
              throw const FormatException('Number has multiple decimal points');
            }
            dotSeen = true;
          }
          buffer.write(expression[i]);
          i++;
        }
        final text = buffer.toString();
        if (text == '.') {
          throw const FormatException('Lone decimal point');
        }
        tokens.add(_Token(_TokenType.number, text));
        continue;
      }

      switch (char) {
        case '+':
        case '-':
        case '*':
        case '/':
        case times:
        case divide:
          tokens.add(_Token(_TokenType.operator, _normalizeOperator(char)));
          break;
        case '%':
          tokens.add(const _Token(_TokenType.percent, '%'));
          break;
        case '(':
          tokens.add(const _Token(_TokenType.leftParen, '('));
          break;
        case ')':
          tokens.add(const _Token(_TokenType.rightParen, ')'));
          break;
        default:
          throw FormatException('Unexpected character: $char');
      }
      i++;
    }

    return tokens;
  }

  String _normalizeOperator(String op) {
    if (op == times) return '*';
    if (op == divide) return '/';
    return op;
  }

  List<_Token> _toReversePolish(List<_Token> tokens) {
    final output = <_Token>[];
    final operators = <_Token>[];
    _Token? previous;

    for (final token in tokens) {
      switch (token.type) {
        case _TokenType.number:
          output.add(token);
          break;
        case _TokenType.percent:
          // Percent acts on the value immediately to its left.
          output.add(token);
          break;
        case _TokenType.operator:
          final isUnary = previous == null ||
              previous.type == _TokenType.operator ||
              previous.type == _TokenType.unaryMinus ||
              previous.type == _TokenType.leftParen;
          if (isUnary) {
            // A unary plus is a no-op; a unary minus becomes a dedicated,
            // right-associative negation operator that binds tighter than the
            // binary operators (so `3×-2` is `3×(-2)`, not `(3×0)-2`).
            if (token.value == '-') {
              operators.add(const _Token(_TokenType.unaryMinus, 'u-'));
            }
            break;
          }
          while (operators.isNotEmpty &&
              (operators.last.type == _TokenType.operator ||
                  operators.last.type == _TokenType.unaryMinus) &&
              _precedence(_opValue(operators.last)) >=
                  _precedence(token.value)) {
            output.add(operators.removeLast());
          }
          operators.add(token);
          break;
        case _TokenType.unaryMinus:
          // Produced internally only; never emitted by the tokenizer.
          operators.add(token);
          break;
        case _TokenType.leftParen:
          operators.add(token);
          break;
        case _TokenType.rightParen:
          while (operators.isNotEmpty &&
              operators.last.type != _TokenType.leftParen) {
            output.add(operators.removeLast());
          }
          if (operators.isEmpty) {
            throw const FormatException('Mismatched parentheses');
          }
          operators.removeLast(); // Discard the left parenthesis.
          break;
      }
      previous = token;
    }

    while (operators.isNotEmpty) {
      final op = operators.removeLast();
      if (op.type == _TokenType.leftParen) {
        throw const FormatException('Mismatched parentheses');
      }
      output.add(op);
    }

    return output;
  }

  double _evaluateRpn(List<_Token> rpn) {
    final stack = <double>[];

    for (final token in rpn) {
      switch (token.type) {
        case _TokenType.number:
          stack.add(double.parse(token.value));
          break;
        case _TokenType.percent:
          if (stack.isEmpty) {
            throw const FormatException('Nothing to apply percent to');
          }
          stack.add(stack.removeLast() / 100);
          break;
        case _TokenType.unaryMinus:
          if (stack.isEmpty) {
            throw const FormatException('Nothing to negate');
          }
          stack.add(-stack.removeLast());
          break;
        case _TokenType.operator:
          if (stack.length < 2) {
            throw const FormatException('Incomplete expression');
          }
          final b = stack.removeLast();
          final a = stack.removeLast();
          stack.add(_applyOperator(token.value, a, b));
          break;
        case _TokenType.leftParen:
        case _TokenType.rightParen:
          throw const FormatException('Unexpected parenthesis');
      }
    }

    if (stack.length != 1) {
      throw const FormatException('Incomplete expression');
    }
    return stack.single;
  }

  double _applyOperator(String op, double a, double b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        if (b == 0) {
          throw const DivideByZeroException();
        }
        return a / b;
      default:
        throw FormatException('Unknown operator: $op');
    }
  }

  String _opValue(_Token token) =>
      token.type == _TokenType.unaryMinus ? 'u-' : token.value;

  int _precedence(String op) {
    switch (op) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
        return 2;
      case 'u-':
        return 3;
      default:
        return 0;
    }
  }

  bool _isDigit(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39;
  }
}

/// Thrown when an expression attempts to divide by zero.
class DivideByZeroException implements Exception {
  const DivideByZeroException();

  @override
  String toString() => 'Cannot divide by zero';
}

enum _TokenType { number, operator, unaryMinus, percent, leftParen, rightParen }

class _Token {
  const _Token(this.type, this.value);

  final _TokenType type;
  final String value;

  @override
  String toString() => '$type($value)';
}
