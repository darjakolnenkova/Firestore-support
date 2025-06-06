import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryController {
  const HistoryController();

  Stream<List<Map<String, dynamic>>> getHistoryStream() {
    return FirebaseFirestore.instance
        .collection('calculator_history')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'expression': data['expression'] ?? '',
        'result': data['result'] ?? '',
        'timestamp': data['timestamp'],
        'is_conversion': data['is_conversion'] ?? false,
        'id': doc.id,
      };
    }).toList());
  }

  Future<void> deleteItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('calculator_history')
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception('Ошибка удаления: $e');
    }
  }

  Future<void> clearAllHistory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('calculator_history')
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  String formatTimestamp(Timestamp timestamp) {
    return timestamp.toDate().toLocal().toString().substring(0, 16);
  }
}