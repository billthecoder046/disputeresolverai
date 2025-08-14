import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateLabel extends StatelessWidget {
  final DateTime timestamp;

  const DateLabel({super.key, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay = DateTime(timestamp.year, timestamp.month, timestamp.day);

    String label = messageDay == today
        ? "Today"
        : messageDay == yesterday
        ? "Yesterday"
        : DateFormat('MMMM d, yyyy').format(timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
    );
  }
}
