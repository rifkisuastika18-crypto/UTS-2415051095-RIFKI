import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/upcoming_task_card.dart';

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
              // HEADER
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

              // RINGKASAN TUGAS DARI SUPABASE
              const Text(
                'Ringkasan Tugas',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'Total Tugas',
                              value: taskProvider.totalTasks.toString(),
                              icon: Icons.assignment,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SummaryCard(
                              title: 'Dikerjakan',
                              value: taskProvider.inProgressTasks.toString(),
                              icon: Icons.pending_actions,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'Selesai',
                              value: taskProvider.completedTasks.toString(),
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SummaryCard(
                              title: 'Belum Selesai',
                              value: taskProvider.pendingTasks.toString(),
                              icon: Icons.warning,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              // MOTIVASI BELAJAR DARI REST API
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Motivasi Belajar',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    tooltip: 'Muat ulang kutipan',
                    onPressed: () {
                      context.read<QuoteProvider>().fetchQuotes();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                  ),
                ],
              ),

              Consumer<QuoteProvider>(
                builder: (context, provider, child) {
                  // LOADING STATE
                  if (provider.isLoading) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Mengambil kutipan dari API...'),
                        ],
                      ),
                    );
                  }

                  // ERROR STATE
                  if (provider.errorMessage != null) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Gagal memuat kutipan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            provider.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: provider.fetchQuotes,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // EMPTY STATE
                  if (provider.quotes.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Belum ada kutipan tersedia.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // DATA BERHASIL DIMUAT
                  final quote = provider.quotes.first;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.format_quote,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          quote.quote,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '— ${quote.author}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // TUGAS TERBARU DARI SUPABASE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tugas Terbaru',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '3 tugas terakhir',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  // LOADING STATE
                  if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // ERROR STATE
                  if (taskProvider.errorMessage != null &&
                      taskProvider.tasks.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Gagal memuat tugas terbaru',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            taskProvider.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: taskProvider.fetchTasks,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // EMPTY STATE
                  if (taskProvider.tasks.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Belum ada tugas terbaru.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // MENGAMBIL 3 TUGAS TERBARU
                  final recentTasks = taskProvider.tasks.take(3).toList();

                  return Column(
                    children: recentTasks.map((task) {
                      Color statusColor;

                      if (task.status == 'Selesai') {
                        statusColor = Colors.green;
                      } else if (task.status == 'Dikerjakan') {
                        statusColor = Colors.orange;
                      } else {
                        statusColor = Colors.blue;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: UpcomingTaskCard(
                          title: task.title,
                          description: task.description,
                          deadline: task.deadline,
                          status: task.status,
                          color: statusColor,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
