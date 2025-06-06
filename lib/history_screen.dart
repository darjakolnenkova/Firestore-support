import 'package:flutter/material.dart';
import 'controllers/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  final HistoryController _controller = const HistoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История операций'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showClearDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('История пуста'));
          }

          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final timestamp = item['timestamp'] != null
                  ? _controller.formatTimestamp(item['timestamp'])
                  : '';

              return Dismissible(
                key: Key(item['id']),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _controller.deleteItem(item['id']),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      item['is_conversion']
                          ? '${item['expression']} → ${item['result']}'
                          : '${item['expression']} = ${item['result']}',
                    ),
                    subtitle: Text(timestamp),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Очистить историю'),
          content: const Text('Вы уверены, что хотите удалить всю историю?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _controller.clearAllHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('История очищена')),
                );
              },
              child: const Text('Очистить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}