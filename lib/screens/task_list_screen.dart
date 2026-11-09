import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_item.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  // Membuka halaman detail tugas
  Future<void> openTaskDetail(BuildContext context, TaskItem task) async {
    final updatedTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );

    if (updatedTask != null && context.mounted) {
      try {
        final taskToUpdate = TaskItem(
          id: task.id,
          title: updatedTask.title,
          description: updatedTask.description,
          deadline: updatedTask.deadline,
          status: updatedTask.status,
        );

        await context.read<TaskProvider>().updateTask(taskToUpdate);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil diperbarui!')),
        );
      } catch (error) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui tugas: $error')),
        );
      }
    }
  }

  // Konfirmasi sebelum menghapus tugas
  Future<void> confirmDeleteTask(BuildContext context, TaskItem task) async {
    if (task.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID tugas tidak ditemukan.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Tugas?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus tugas '
            '"${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await context.read<TaskProvider>().deleteTask(task.id!);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus tugas: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          // Loading
          if (provider.isLoading && provider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (provider.errorMessage != null && provider.tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text('Gagal memuat daftar tugas'),
                    const SizedBox(height: 8),
                    Text(provider.errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: provider.fetchTasks,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state
          if (provider.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada tugas tersimpan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Tambahkan tugas melalui menu Tambah.'),
                ],
              ),
            );
          }

          // Responsive layout
          return LayoutBuilder(
            builder: (context, constraints) {
              final tasks = provider.tasks;

              Widget buildTaskCard(TaskItem task) {
                return TaskCard(
                  task: task,
                  onTap: () => openTaskDetail(context, task),
                  onDelete: provider.isMutating
                      ? null
                      : () => confirmDeleteTask(context, task),
                );
              }

              // Tampilan HP
              if (constraints.maxWidth < 700) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return buildTaskCard(tasks[index]);
                  },
                );
              }

              // Tampilan tablet
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
                  return buildTaskCard(tasks[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
