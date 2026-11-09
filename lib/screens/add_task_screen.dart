import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_item.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();

  String selectedStatus = 'Belum selesai';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  // CREATE: Simpan tugas ke Supabase
  Future<void> saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<TaskProvider>();

    final newTask = TaskItem(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      deadline: deadlineController.text.trim(),
      status: selectedStatus,
    );

    try {
      await provider.addTask(newTask);

      if (!mounted) return;

      titleController.clear();
      descriptionController.clear();
      deadlineController.clear();

      setState(() {
        selectedStatus = 'Belum selesai';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil disimpan ke database!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan tugas: $error'),
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
          'Tambah Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nama tugas
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Tugas',
                      prefixIcon: Icon(Icons.assignment),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tugas harus diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Deskripsi
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi Tugas',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi harus diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Deadline
                  TextFormField(
                    controller: deadlineController,
                    decoration: const InputDecoration(
                      labelText: 'Deadline',
                      hintText: 'Contoh: 20 November 2026',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deadline harus diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Status tugas
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status Tugas',
                      prefixIcon: Icon(Icons.flag),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Belum selesai',
                        child: Text('Belum selesai'),
                      ),
                      DropdownMenuItem(
                        value: 'Dikerjakan',
                        child: Text('Dikerjakan'),
                      ),
                      DropdownMenuItem(
                        value: 'Selesai',
                        child: Text('Selesai'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  // Tombol simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: provider.isMutating ? null : saveTask,
                      icon: provider.isMutating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        provider.isMutating ? 'Menyimpan...' : 'Simpan Tugas',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
