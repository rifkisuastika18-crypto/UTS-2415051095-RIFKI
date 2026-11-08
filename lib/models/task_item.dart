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

// Data sementara untuk aplikasi TaskMate
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
