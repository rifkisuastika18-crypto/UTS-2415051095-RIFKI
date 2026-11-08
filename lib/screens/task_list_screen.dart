import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<TaskItem> tasks = taskData;

  Future<void> openTaskDetail(TaskItem task) async {
    final updatedTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );

    if (updatedTask != null) {
      setState(() {
        final index = tasks.indexOf(task);

        if (index != -1) {
          tasks[index] = updatedTask;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (tasks.isEmpty) {
            return const Center(child: Text('Belum ada tugas'));
          }

          // Tampilan HP menggunakan ListView
          if (constraints.maxWidth < 700) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return TaskCard(task: task, onTap: () => openTaskDetail(task));
              },
            );
          }

          // Tampilan tablet menggunakan GridView
          final columnCount = constraints.maxWidth >= 1000 ? 3 : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tasks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskCard(task: task, onTap: () => openTaskDetail(task));
            },
          );
        },
      ),
    );
  }
}
