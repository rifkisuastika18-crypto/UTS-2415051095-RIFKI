import '../models/task_item.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService taskService;

  TaskRepository({required this.taskService});

  // READ
  Future<List<TaskItem>> getTasks() async {
    return await taskService.fetchTasks();
  }

  // CREATE
  Future<void> addTask(TaskItem task) async {
    await taskService.addTask(task);
  }

  // UPDATE
  Future<void> updateTask(TaskItem task) async {
    await taskService.updateTask(task);
  }

  // DELETE
  Future<void> deleteTask(String id) async {
    await taskService.deleteTask(id);
  }
}
