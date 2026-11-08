import 'package:flutter/material.dart';

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
              const Text(
                'Ringkasan Tugas',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
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
