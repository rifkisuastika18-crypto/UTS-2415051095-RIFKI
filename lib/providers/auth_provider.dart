import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get profile => _profile;

  User? get currentUser => authRepository.currentUser;

  bool get isLoggedIn => currentUser != null;

  // MENGAMBIL PROFIL PENGGUNA
  Future<void> loadProfile() async {
    try {
      _profile = await authRepository.getProfile();

      debugPrint('HASIL PROFIL SUPABASE: $_profile');

      _errorMessage = null;
    } catch (e) {
      debugPrint('ERROR PROFIL SUPABASE: $e');

      _profile = null;
      _errorMessage = 'Gagal mengambil data profil: $e';
    }

    notifyListeners();
  }

  // REGISTER
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);

    try {
      await authRepository.register(
        email: email,
        password: password,
        name: name,
      );

      _errorMessage = null;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat mendaftar.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // LOGIN
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);

    try {
      await authRepository.login(email: email, password: password);

      _errorMessage = null;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat login.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // LOGOUT
  Future<void> logout() async {
    _setLoading(true);

    try {
      await authRepository.logout();
      _profile = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal logout. Silakan coba lagi.';
    } finally {
      _setLoading(false);
    }
  }

  // LOADING
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
