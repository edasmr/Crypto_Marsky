import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppAuthState {}

class AuthInitial extends AppAuthState {}

class AuthLoading extends AppAuthState {}

class Authenticated extends AppAuthState {
  final User user;

  Authenticated(this.user);
}

class RegisteredSuccess extends AppAuthState {}

class Unauthenticated extends AppAuthState {}

class AuthError extends AppAuthState {
  final String message;

  AuthError(this.message);
}
