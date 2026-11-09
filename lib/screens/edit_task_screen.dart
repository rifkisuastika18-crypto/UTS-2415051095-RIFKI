import 'package:flutter/material.dart';

import '../models/task_item.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskItem task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController deadlineController;

  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    // Mengisi form dengan data tugas sebelumnya
    titleController = TextEditingController(text: widget.task.title);

    descriptionController = TextEditingController(
      text: widget.task.description,
    );

    deadlineController = TextEditingController(text: widget.task.deadline);

    selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  // VALIDASI: Memeriksa input wajib
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    return null;
  }

  // UPDATE: Menyimpan perubahan tugas
  void saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedTask = TaskItem(
      id: widget.task.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      deadline: deadlineController.text.trim(),
      status: selectedStatus,
    );

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  return validateRequired(value, 'Nama tugas');
                },
              ),

              const SizedBox(height: 16),

              // Deskripsi tugas
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return validateRequired(value, 'Deskripsi');
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
                  return validateRequired(value, 'Deadline');
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
                  DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status tugas wajib dipilih';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              // Tombol simpan perubahan
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: saveTask,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Tombol batal
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
