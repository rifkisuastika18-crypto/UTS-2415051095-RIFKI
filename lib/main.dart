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

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabasePublishableKey,
  );

  final supabase = Supabase.instance.client;

  // Login anonim jika belum memiliki sesi
  if (supabase.auth.currentSession == null) {
    await supabase.auth.signInAnonymously();
  }

  // Repository REST API
  final quoteRepository = QuoteRepository(quoteService: QuoteService());

  // Repository Database
  final taskRepository = TaskRepository(taskService: TaskService());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<QuoteProvider>(
          create: (_) =>
              QuoteProvider(repository: quoteRepository)..fetchQuotes(),
        ),

        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(repository: taskRepository)..fetchTasks(),
        ),
      ],
      child: const TaskMateApp(),
    ),
  );
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
