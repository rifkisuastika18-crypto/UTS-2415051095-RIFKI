import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';

import 'providers/quote_provider.dart';
import 'providers/task_provider.dart';

import 'repositories/quote_repository.dart';
import 'repositories/task_repository.dart';

import 'services/quote_service.dart';
import 'services/task_service.dart';

import 'screens/home_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase.
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabasePublishableKey,
  );

  // Repository REST API.
  final quoteRepository = QuoteRepository(quoteService: QuoteService());

  // Repository database.
  final taskRepository = TaskRepository(taskService: TaskService());

  // Buat Provider sebelum aplikasi dijalankan.
  final quoteProvider = QuoteProvider(repository: quoteRepository);

  final taskProvider = TaskProvider(repository: taskRepository);

  // Tampilkan aplikasi terlebih dahulu.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<QuoteProvider>.value(value: quoteProvider),
        ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
      ],
      child: const TaskMateApp(),
    ),
  );

  // Jalankan proses login setelah aplikasi tampil.
  quoteProvider.fetchQuotes();
  initializeAuth(taskProvider);
}

// Login Supabase dilakukan di latar belakang.
Future<void> initializeAuth(TaskProvider taskProvider) async {
  try {
    final supabase = Supabase.instance.client;

    if (supabase.auth.currentSession == null) {
      await supabase.auth.signInAnonymously();
    }

    // Ambil data tugas setelah login berhasil.
    await taskProvider.fetchTasks();

    debugPrint('Supabase berhasil terhubung.');
  } catch (error) {
    debugPrint('Koneksi Supabase gagal: $error');
    debugPrint('TaskMate tetap dapat dibuka.');
  }
}

class TaskMateApp extends StatelessWidget {
  const TaskMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskMate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2878D0)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    TaskListScreen(),
    AddTaskScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Tambah',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
