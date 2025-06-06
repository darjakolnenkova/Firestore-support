import 'package:cloud_firestore/cloud_firestore.dart';

class KmMileConverterController {
  Future<double> convertKmToMiles(double km) async {
    final result = km * 0.621371;
    await _saveConversion(km, result);
    return result;
  }

  Future<void> _saveConversion(double km, double miles) async {
    await FirebaseFirestore.instance.collection('calculator_history').add({
      'expression': '$km км',
      'result': '${miles.toStringAsFixed(2)} миль',
      'timestamp': FieldValue.serverTimestamp(),
      'is_conversion': true,
    });
  }
}