import 'package:flutter_test/flutter_test.dart';
import 'package:firestore_support/main.dart';
import 'package:firestore_support/calculator_ui.dart';

void main() {
  testWidgets('CalculatorApp test', (WidgetTester tester) async {
    // Строим CalculatorApp вместо MyApp
    await tester.pumpWidget(const CalculatorApp());

    // Проверяем наличие заголовка
    expect(find.text('Калькулятор'), findsOneWidget);

    // Проверяем наличие основного виджета
    expect(find.byType(CalculatorUI), findsOneWidget);
  });
}