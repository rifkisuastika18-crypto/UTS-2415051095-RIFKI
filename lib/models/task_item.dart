class TaskItem {
  final String? id;
  String title;
  String description;
  String deadline;
  String status;

  TaskItem({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
  });

  // Mengubah data JSON Supabase menjadi objek TaskItem
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: json['deadline'] as String,
      status: json['status'] as String,
    );
  }
}

// Data sementara.
// Nanti akan digantikan dengan data dari Supabase.
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
