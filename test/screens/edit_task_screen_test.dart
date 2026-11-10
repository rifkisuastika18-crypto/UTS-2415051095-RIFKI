import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmate/models/task_item.dart';
import 'package:taskmate/screens/edit_task_screen.dart';

void main() {
  final sampleTask = TaskItem(
    id: 'task-001',
    title: 'Tugas Pemrograman Mobile',
    description: 'Membuat aplikasi Flutter',
    deadline: '20 November 2026',
    status: 'Belum selesai',
  );

  testWidgets('Edit Task menampilkan data tugas sebelumnya',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EditTaskScreen(task: sampleTask),
      ),
    );

    expect(find.text('Edit Tugas'), findsOneWidget);
    expect(find.text('Tugas Pemrograman Mobile'), findsOneWidget);
    expect(find.text('Membuat aplikasi Flutter'), findsOneWidget);
    expect(find.text('20 November 2026'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);
  });

  testWidgets('Edit Task dapat membuka DatePicker',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EditTaskScreen(task: sampleTask),
      ),
    );

    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pumpAndSettle();

    expect(find.text('Pilih Deadline Tugas'), findsOneWidget);
    expect(find.text('PILIH'), findsOneWidget);
    expect(find.text('BATAL'), findsOneWidget);
  });
}
