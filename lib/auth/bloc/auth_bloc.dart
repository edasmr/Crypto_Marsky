import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AppAuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  void _onAppStarted(AppStarted event, Emitter<AppAuthState> emit) {
    final user = repository.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await repository.login(event.email, event.password);

      if (response.session != null) {
        emit(Authenticated(response.user!));
        debugPrint('user: ${response.user}');
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await repository.register(event.email, event.password);
      await repository.logout();
      emit(RegisteredSuccess());
    } catch (e) {
      debugPrint('REGISTER ERROR RAW: $e');

      if (e is AuthApiException) {
        if (e.statusCode == ' 422') {
          emit(AuthError('This email address is already registered.'));
          return;
        }
        emit(AuthError(e.message));
        return;
      }

      emit(AuthError('An error occurred, please try again.'));
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    await repository.logout();
    emit(Unauthenticated());
  }
}
