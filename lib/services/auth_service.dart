import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService({SupabaseClient? client})
    : supabase = client ?? Supabase.instance.client;

  // REGISTER
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
  }

  // LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // USER YANG SEDANG LOGIN
  User? get currentUser => supabase.auth.currentUser;

  // MEMANTAU PERUBAHAN SESSION
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  // // MENGAMBIL PROFIL PENGGUNA
  // MENGAMBIL PROFIL PENGGUNA
  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;

    if (user == null) return null;

    final response = await supabase
        .from('profiles')
        .select('name, role')
        .eq('id', user.id)
        .maybeSingle();

    return response;
  }
}
