import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task_item.dart';

class TaskService {
  final SupabaseClient supabase;

  TaskService({SupabaseClient? client})
    : supabase = client ?? Supabase.instance.client;

  // Memastikan pengguna sudah memiliki sesi login
  String get currentUserId {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user.id;
  }

  // READ: Mengambil daftar tugas dari database
  Future<List<TaskItem>> fetchTasks() async {
    final data = await supabase
        .from('tasks')
        .select()
        .eq('user_id', currentUserId)
        .order('created_at', ascending: false);

    return data.map((item) => TaskItem.fromJson(item)).toList();
  }

  // CREATE: Menambahkan tugas baru
  Future<void> addTask(TaskItem task) async {
    await supabase.from('tasks').insert({
      'user_id': currentUserId,
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'status': task.status,
    });
  }

  // UPDATE: Mengubah tugas
  Future<void> updateTask(TaskItem task) async {
    if (task.id == null) {
      throw Exception('ID tugas tidak ditemukan.');
    }

    await supabase
        .from('tasks')
        .update({
          'title': task.title,
          'description': task.description,
          'deadline': task.deadline,
          'status': task.status,
        })
        .eq('id', task.id!)
        .eq('user_id', currentUserId);
  }

  // DELETE: Menghapus tugas
  Future<void> deleteTask(String id) async {
    await supabase
        .from('tasks')
        .delete()
        .eq('id', id)
        .eq('user_id', currentUserId);
  }
}
