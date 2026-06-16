import 'package:flutter/foundation.dart';

import 'calculator_engine.dart';

/// A single completed calculation, kept for the history list.
@immutable
class HistoryEntry {
  const HistoryEntry({required this.expression, required this.result});

  final String expression;
  final String result;
}

/// Holds the live state of the calculator and translates button presses into
/// changes to the current expression and result. Extends [ChangeNotifier] so
/// the UI can rebuild reactively whenever the state changes.
class CalculatorController extends ChangeNotifier {
  final CalculatorEngine _engine = const CalculatorEngine();

  String _expression = '';
  String _result = '0';
  bool _hasError = false;
  bool _justEvaluated = false;
  final List<HistoryEntry> _history = <HistoryEntry>[];

  /// The expression as the user has typed it, using display symbols.
  String get expression => _expression;

  /// The current result (live preview, or the final value after `=`).
  String get result => _result;

  /// Whether the last action produced an error.
  bool get hasError => _hasError;

  /// Past calculations, most recent first.
  List<HistoryEntry> get history => List.unmodifiable(_history);

  /// Whether `=` was the most recent meaningful action.
  bool get justEvaluated => _justEvaluated;

  /// Clears the stored calculation history.
  void clearHistory() {
    if (_history.isEmpty) return;
    _history.clear();
    notifyListeners();
  }

  /// Restores a previous result into the current expression.
  void recallResult(String value) {
    _expression = value;
    _justEvaluated = true;
    _hasError = false;
    _updatePreview();
    notifyListeners();
  }

  static const Set<String> _operators = {'+', '-', CalculatorEngine.times, CalculatorEngine.divide};

  /// Handles a single key from the keypad.
  void input(String key) {
    switch (key) {
      case 'AC':
        _clearAll();
        break;
      case 'DEL':
        _delete();
        break;
      case '=':
        _evaluate();
        break;
      case '%':
        _appendPercent();
        break;
      case '+/-':
        _toggleSign();
        break;
      default:
        _appendToken(key);
    }
    notifyListeners();
  }

  void _clearAll() {
    _expression = '';
    _result = '0';
    _hasError = false;
    _justEvaluated = false;
  }

  void _delete() {
    if (_hasError) {
      _clearAll();
      return;
    }
    if (_justEvaluated) {
      // Editing a finished result starts a fresh expression from it.
      _expression = _result == '0' ? '' : _result;
      _justEvaluated = false;
    }
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _updatePreview();
    }
  }

  void _appendToken(String token) {
    if (_hasError) {
      _clearAll();
    }

    final isOperator = _operators.contains(token);

    if (_justEvaluated) {
      // Continue calculating from the previous result with an operator, or
      // begin a brand new expression with a digit/paren.
      _expression = isOperator ? _result : '';
      _justEvaluated = false;
    }

    if (isOperator) {
      if (_expression.isEmpty) {
        // Allow a leading minus, but otherwise an operator needs an operand.
        if (token == '-') {
          _expression = token;
        }
      } else if (_operators.contains(_lastChar)) {
        // Replace a trailing operator rather than stacking another.
        _expression = _expression.substring(0, _expression.length - 1) + token;
      } else {
        _expression += token;
      }
    } else if (token == '.') {
      _appendDecimal();
    } else {
      _expression += token;
    }

    _updatePreview();
  }

  void _appendDecimal() {
    // Prevent two decimals within the same number segment.
    final segment = _currentNumberSegment();
    if (segment.contains('.')) {
      return;
    }
    if (segment.isEmpty) {
      _expression += '0.';
    } else {
      _expression += '.';
    }
  }

  void _appendPercent() {
    if (_hasError) {
      _clearAll();
      return;
    }
    if (_justEvaluated) {
      _expression = _result;
      _justEvaluated = false;
    }
    if (_expression.isEmpty || _operators.contains(_lastChar)) {
      return;
    }
    _expression += '%';
    _updatePreview();
  }

  void _toggleSign() {
    if (_hasError) {
      _clearAll();
      return;
    }
    if (_justEvaluated) {
      _expression = _result;
      _justEvaluated = false;
    }
    // Toggle the sign of the trailing number segment.
    final segment = _currentNumberSegment();
    if (segment.isEmpty) {
      return;
    }
    final start = _expression.length - segment.length;
    final before = _expression.substring(0, start);
    if (before.endsWith('-') &&
        (before.length == 1 || _operators.contains(before[before.length - 2]) || before.endsWith('('))) {
      // Already negated: remove the leading minus.
      _expression = before.substring(0, before.length - 1) + segment;
    } else {
      _expression = '$before-$segment';
    }
    _updatePreview();
  }

  void _evaluate() {
    if (_expression.isEmpty) {
      return;
    }
    try {
      final value = _engine.evaluateToString(_expression);
      // Avoid recording a no-op like "5 =" that just echoes the input.
      if (value != _expression) {
        _history.insert(
          0,
          HistoryEntry(expression: _expression, result: value),
        );
        if (_history.length > 50) {
          _history.removeRange(50, _history.length);
        }
      }
      _result = value;
      _hasError = false;
      _justEvaluated = true;
    } on DivideByZeroException {
      _setError("Can't divide by zero");
    } on FormatException {
      _setError('Invalid expression');
    }
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }
    try {
      _result = _engine.evaluateToString(_expression);
      _hasError = false;
    } on Object {
      // Mid-typing expressions are often incomplete; keep the last good
      // preview instead of flashing an error.
    }
  }

  void _setError(String message) {
    _result = message;
    _hasError = true;
    _justEvaluated = false;
  }

  /// The digits of the number currently being typed (after the last operator
  /// or parenthesis).
  String _currentNumberSegment() {
    var i = _expression.length;
    while (i > 0) {
      final ch = _expression[i - 1];
      if (_operators.contains(ch) || ch == '(' || ch == ')' || ch == '%') {
        break;
      }
      i--;
    }
    return _expression.substring(i);
  }

  String get _lastChar =>
      _expression.isEmpty ? '' : _expression[_expression.length - 1];
}
