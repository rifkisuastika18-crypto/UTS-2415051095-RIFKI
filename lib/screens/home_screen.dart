import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';
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

              // Ringkasan tugas
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

              // REST API: Motivasi Belajar
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
                  // Loading state
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

                  // Error state
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

                  // Empty state
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

                  // Data berhasil dimuat dari API
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

              // Tugas terdekat
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
