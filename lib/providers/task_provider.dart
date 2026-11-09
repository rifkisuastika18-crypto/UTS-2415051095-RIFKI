import 'package:flutter/foundation.dart';

import '../models/task_item.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskProvider({required this.repository});

  List<TaskItem> _tasks = [];
  bool _isLoading = false;
  bool _isMutating = false;
  String? _errorMessage;

  List<TaskItem> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get isMutating => _isMutating;
  String? get errorMessage => _errorMessage;

  // READ: Mengambil semua tugas
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
