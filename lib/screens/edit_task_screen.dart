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

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month - 1];
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2035, 12, 31),
      helpText: 'Pilih Deadline Tugas',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
    );

    if (selectedDate != null) {
      setState(() {
        deadlineController.text =
            '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}';
      });
    }
  }

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
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Tugas',
                  prefixIcon: Icon(Icons.assignment),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateRequired(value, 'Nama tugas'),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateRequired(value, 'Deskripsi'),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: deadlineController,
                readOnly: true,
                onTap: _selectDeadline,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  hintText: 'Pilih tanggal deadline',
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateRequired(value, 'Deadline'),
              ),

              const SizedBox(height: 16),

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

              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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
