import 'package:flutter/material.dart';

void main() {
  runApp(const TaskMateApp());
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

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();

  String selectedStatus = 'Belum selesai';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void saveTask() {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        deadlineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua kolom harus diisi!')));
      return;
    }

    taskData.add(
      TaskItem(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        deadline: deadlineController.text.trim(),
        status: selectedStatus,
      ),
    );

    titleController.clear();
    descriptionController.clear();
    deadlineController.clear();

    setState(() {
      selectedStatus = 'Belum selesai';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tugas berhasil ditambahkan!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Tugas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Tugas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: 'Deadline',
                hintText: 'Contoh: 20 November 2026',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status Tugas',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Belum selesai',
                  child: Text('Belum selesai'),
                ),
                DropdownMenuItem(
                  value: 'Dikerjakan',
                  child: Text('Dikerjakan'),
                ),
                DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveTask,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profil Pengguna')));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Mahasiswa! 👋',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Selamat datang di TaskMate',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Judul ringkasan
              const Text(
                'Ringkasan Tugas',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              // Kartu ringkasan
              const Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Tugas',
                      value: '12',
                      icon: Icons.assignment,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Dikerjakan',
                      value: '5',
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Selesai',
                      value: '7',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Terlambat',
                      value: '0',
                      icon: Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Daftar tugas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tugas Terdekat',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Minggu ini',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const UpcomingTaskCard(
                title: 'Pemrograman Mobile',
                description: 'Membuat aplikasi Flutter',
                deadline: '10 November 2026',
                status: 'Dikerjakan',
                color: Colors.orange,
              ),

              const SizedBox(height: 12),

              const UpcomingTaskCard(
                title: 'Kecerdasan Buatan',
                description: 'Menyelesaikan laporan UTS',
                deadline: '12 November 2026',
                status: 'Belum selesai',
                color: Colors.blue,
              ),

              const SizedBox(height: 12),

              const UpcomingTaskCard(
                title: 'Basis Data',
                description: 'Membuat rancangan database',
                deadline: '15 November 2026',
                status: 'Dikerjakan',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget kartu ringkasan
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// Widget kartu tugas terdekat
class UpcomingTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String deadline;
  final String status;
  final Color color;

  const UpcomingTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 65,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      deadline,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem {
  String title;
  String description;
  String deadline;
  String status;

  TaskItem({
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
  });
}

final List<TaskItem> taskData = [
  TaskItem(
    title: 'Pemrograman Mobile',
    description: 'Membuat aplikasi Flutter dengan API',
    deadline: '10 November 2026',
    status: 'Dikerjakan',
  ),
  TaskItem(
    title: 'Kecerdasan Buatan',
    description: 'Menyelesaikan laporan UTS',
    deadline: '12 November 2026',
    status: 'Belum selesai',
  ),
  TaskItem(
    title: 'Basis Data',
    description: 'Membuat rancangan database',
    deadline: '15 November 2026',
    status: 'Dikerjakan',
  ),
];

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<TaskItem> tasks = taskData;

  Future<void> openTaskDetail(TaskItem task) async {
    final updatedTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );

    if (updatedTask != null) {
      setState(() {
        final index = tasks.indexOf(task);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Belum ada tugas'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(child: Icon(Icons.assignment)),
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${task.description}\nDeadline: ${task.deadline}\nStatus: ${task.status}',
                      ),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => openTaskDetail(task),
                  ),
                );
              },
            ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final TaskItem task;

  const TaskDetailScreen({super.key, required this.task});

  Future<void> openEditScreen(BuildContext context) async {
    final updatedTask = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    );

    if (updatedTask != null && context.mounted) {
      Navigator.pop(context, updatedTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.assignment, size: 55, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              task.title,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Deskripsi: ${task.description}'),
            const SizedBox(height: 12),
            Text('Deadline: ${task.deadline}'),
            const SizedBox(height: 12),
            Text('Status: ${task.status}'),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => openEditScreen(context),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final TaskItem task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController deadlineController;
  String selectedStatus = 'Dikerjakan';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    deadlineController = TextEditingController(text: widget.task.deadline);
    selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void saveTask() {
    final updatedTask = TaskItem(
      title: titleController.text,
      description: descriptionController.text,
      deadline: deadlineController.text,
      status: selectedStatus,
    );

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Tugas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: 'Deadline',
                hintText: 'Contoh: 20 November 2026',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status Tugas',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Belum selesai',
                  child: Text('Belum selesai'),
                ),
                DropdownMenuItem(
                  value: 'Dikerjakan',
                  child: Text('Dikerjakan'),
                ),
                DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveTask,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
