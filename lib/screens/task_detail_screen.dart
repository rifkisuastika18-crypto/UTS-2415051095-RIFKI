import 'package:flutter/material.dart';

import '../models/task_item.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskItem task;

  const TaskDetailScreen({super.key, required this.task});

  Future<void> openEditScreen(BuildContext context) async {
    final updatedTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    );

    if (updatedTask != null && context.mounted) {
      Navigator.pop(context, updatedTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.assignment, size: 55, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              task.title,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Deskripsi: ${task.description}'),
            const SizedBox(height: 12),
            Text('Deadline: ${task.deadline}'),
            const SizedBox(height: 12),
            Text('Status: ${task.status}'),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => openEditScreen(context),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
