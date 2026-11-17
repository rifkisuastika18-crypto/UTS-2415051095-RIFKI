import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _profileRequested = false;
  bool _isProfileLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_profileRequested) {
      _profileRequested = true;
      _loadProfile();
    }
  }

  // MEMUAT PROFIL PENGGUNA
  Future<void> _loadProfile() async {
    await context.read<AuthProvider>().loadProfile();

    if (mounted) {
      setState(() {
        _isProfileLoading = false;
      });
    }
  }

  // LOGOUT
  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<AuthProvider>().logout();

    if (!context.mounted) return;

    final error = context.read<AuthProvider>().errorMessage;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // DATA PENGGUNA
    final email = authProvider.currentUser?.email ?? 'Tidak tersedia';

    final name = _isProfileLoading
        ? 'Memuat...'
        : authProvider.profile?['name']?.toString() ?? 'Tidak tersedia';

    final role = _isProfileLoading
        ? 'Memuat...'
        : authProvider.profile?['role']?.toString() ?? 'Tidak tersedia';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF2878D0),
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // NAMA PENGGUNA
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Aplikasi Manajemen Tugas Kuliah',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              // NAMA
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Nama Pengguna'),
                  subtitle: Text(name),
                ),
              ),

              // EMAIL
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email Akun'),
                  subtitle: Text(email),
                ),
              ),

              // ROLE
              Card(
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Role Pengguna'),
                  subtitle: Text(role),
                ),
              ),

              // TENTANG APLIKASI
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Tentang Aplikasi'),
                  subtitle: Text('TaskMate - Kelola tugas kuliah'),
                ),
              ),

              const SizedBox(height: 30),

              // TOMBOL LOGOUT
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: authProvider.isLoading
                      ? null
                      : () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: authProvider.isLoading
                      ? const Text('Sedang logout...')
                      : const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
