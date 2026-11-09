import 'package:flutter/material.dart';

import '../models/task_item.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(child: Icon(Icons.assignment)),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${task.description}\n'
            'Deadline: ${task.deadline}\n'
            'Status: ${task.status}',
          ),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              IconButton(
                tooltip: 'Hapus tugas',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
