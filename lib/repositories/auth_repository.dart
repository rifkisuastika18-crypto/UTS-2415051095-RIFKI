
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  // REGISTER
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return await authService.register(
      email: email,
      password: password,
    );
  }

  // LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await authService.login(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> logout() async {
    await authService.logout();
  }

  // USER AKTIF
  User? get currentUser => authService.currentUser;

  // PERUBAHAN SESSION
  Stream<AuthState> get authStateChanges =>
      authService.authStateChanges;
}
