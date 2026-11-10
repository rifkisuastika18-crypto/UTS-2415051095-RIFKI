import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskmate/main.dart';
import 'package:taskmate/config/supabase_config.dart';

import 'package:taskmate/providers/task_provider.dart';
import 'package:taskmate/providers/quote_provider.dart';

import 'package:taskmate/repositories/task_repository.dart';
import 'package:taskmate/repositories/quote_repository.dart';

import 'package:taskmate/services/task_service.dart';
import 'package:taskmate/services/quote_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Membuat penyimpanan tiruan untuk pengujian
    SharedPreferences.setMockInitialValues({});

    // Inisialisasi Supabase
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      publishableKey: SupabaseConfig.supabasePublishableKey,
    );
  });

  testWidgets('TaskMate app loads home screen', (WidgetTester tester) async {
    // Membuat repository tugas
    final taskRepository = TaskRepository(taskService: TaskService());

    // Membuat repository kutipan
    final quoteRepository = QuoteRepository(quoteService: QuoteService());

    // Menyediakan Provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TaskProvider>(
            create: (_) => TaskProvider(repository: taskRepository),
          ),
          ChangeNotifierProvider<QuoteProvider>(
            create: (_) => QuoteProvider(repository: quoteRepository),
          ),
        ],
        child: const TaskMateApp(),
      ),
    );

    // Menampilkan halaman Home
    await tester.pump();

    // Memeriksa komponen halaman Home
    expect(find.text('Halo, Mahasiswa! 👋'), findsOneWidget);
    expect(find.text('Ringkasan Tugas'), findsOneWidget);
  });
}
