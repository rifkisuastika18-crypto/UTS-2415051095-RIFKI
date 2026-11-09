import 'package:flutter/foundation.dart';

import '../models/task_item.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskProvider({required this.repository});

  // State aplikasi
  List<TaskItem> _tasks = [];
  bool _isLoading = false;
  bool _isMutating = false;
  String? _errorMessage;

  // Getter utama
  List<TaskItem> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get isMutating => _isMutating;
  String? get errorMessage => _errorMessage;

  // Ringkasan tugas dari shared state
  int get totalTasks => _tasks.length;

  int get completedTasks {
    return _tasks.where((task) => task.status == 'Selesai').length;
  }

  int get inProgressTasks {
    return _tasks.where((task) => task.status == 'Dikerjakan').length;
  }

  int get pendingTasks {
    return _tasks.where((task) => task.status == 'Belum selesai').length;
  }

  // READ: Mengambil semua tugas dari Supabase
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await repository.getTasks();
    } catch (error) {
      _errorMessage = 'Gagal memuat tugas: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE: Menambahkan tugas
  Future<void> addTask(TaskItem task) async {
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.addTask(task);
      await fetchTasks();
    } catch (error) {
      _errorMessage = 'Gagal menambahkan tugas: $error';
      rethrow;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  // UPDATE: Mengubah tugas
  Future<void> updateTask(TaskItem task) async {
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.updateTask(task);
      await fetchTasks();
    } catch (error) {
      _errorMessage = 'Gagal mengubah tugas: $error';
      rethrow;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  // DELETE: Menghapus tugas
  Future<void> deleteTask(String id) async {
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteTask(id);
      await fetchTasks();
    } catch (error) {
      _errorMessage = 'Gagal menghapus tugas: $error';
      rethrow;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }
}
