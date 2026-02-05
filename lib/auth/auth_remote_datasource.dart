import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  final SupabaseClient client;

  AuthRemoteDatasource(this.client);

  Future<void> login(String email, String password) async {
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register(String email, String password) async {
    await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  bool isLoggedIn() {
    return client.auth.currentSession != null;
  }
}
