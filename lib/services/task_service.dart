import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task_item.dart';

class TaskService {
  final SupabaseClient supabase;

  TaskService({SupabaseClient? client})
    : supabase = client ?? Supabase.instance.client;

  // Memastikan pengguna sudah login
  String get currentUserId {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user.id;
  }

  // READ: RLS menentukan tugas yang boleh dilihat
  Future<List<TaskItem>> fetchTasks() async {
    final data = await supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return data.map((item) => TaskItem.fromJson(item)).toList();
  }

  // CREATE: Tugas baru dimiliki pengguna yang login
  Future<void> addTask(TaskItem task) async {
    await supabase.from('tasks').insert({
      'user_id': currentUserId,
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'status': task.status,
    });
  }

  // UPDATE: RLS menentukan apakah pengguna berhak mengubah tugas
  Future<void> updateTask(TaskItem task) async {
    if (task.id == null) {
      throw Exception('ID tugas tidak ditemukan.');
    }

    final result = await supabase
        .from('tasks')
        .update({
          'title': task.title,
          'description': task.description,
          'deadline': task.deadline,
          'status': task.status,
        })
        .eq('id', task.id!)
        .select();

    if (result.isEmpty) {
      throw Exception('Tidak memiliki izin untuk mengubah tugas ini.');
    }
  }

  // DELETE: RLS menentukan apakah pengguna berhak menghapus tugas
  Future<void> deleteTask(String id) async {
    final result = await supabase.from('tasks').delete().eq('id', id).select();

    if (result.isEmpty) {
      throw Exception('Tidak memiliki izin untuk menghapus tugas ini.');
    }
  }
}
