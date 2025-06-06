import 'package:math_expressions/math_expressions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalculatorController {
  Future<String> evaluateExpression(String expression) async {
    try {
      String parsedExpression = expression.replaceAll('x', '*');
      final parser = ShuntingYardParser();
      final exp = parser.parse(parsedExpression);
      final cm = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, cm);

      String resultStr;
      if (result % 1 == 0) {
        resultStr = result.toInt().toString();
      } else {
        resultStr = result.toStringAsFixed(8).replaceFirst(RegExp(r'\.?0+\$'), '');
      }

      await _saveToHistory(expression, resultStr);
      return resultStr;
    } catch (e) {
      throw Exception("Ошибка вычисления");
    }
  }

  Future<void> _saveToHistory(String expression, String result) async {
    await FirebaseFirestore.instance.collection('calculator_history').add({
      'expression': expression,
      'result': result,
      'timestamp': FieldValue.serverTimestamp(),
      'is_conversion': false,
    });
  }
}