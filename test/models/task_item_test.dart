import 'package:flutter_test/flutter_test.dart';
import 'package:taskmate/models/task_item.dart';

void main() {
  group('TaskItem Model Test', () {
    test('Berhasil mengubah JSON menjadi TaskItem', () {
      final json = {
        'id': '1',
        'title': 'Pemrograman Mobile',
        'description': 'Membuat aplikasi Flutter',
        'deadline': '10 November 2026',
        'status': 'Dikerjakan',
      };

      final task = TaskItem.fromJson(json);

      expect(task.id, '1');
      expect(task.title, 'Pemrograman Mobile');
      expect(task.description, 'Membuat aplikasi Flutter');
      expect(task.deadline, '10 November 2026');
      expect(task.status, 'Dikerjakan');
    });

    test('Data TaskItem sesuai dengan nilai yang diberikan', () {
      final task = TaskItem(
        title: 'Kecerdasan Buatan',
        description: 'Mengerjakan laporan',
        deadline: '12 November 2026',
        status: 'Belum selesai',
      );

      expect(task.title, 'Kecerdasan Buatan');
      expect(task.description, 'Mengerjakan laporan');
      expect(task.deadline, '12 November 2026');
      expect(task.status, 'Belum selesai');
    });
  });
}
