import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/login_page.dart';
import '../features/main_scaffold.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is RegisteredSuccess) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                AuthGateStrings.success,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                AuthGateStrings.emailField,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AuthGateStrings.done,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AppAuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const MainScaffold();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
class AuthGateStrings {
  static const String success = 'Successful';
  static const String emailField = 'Registration successfully created.\nYou can now log in.';
  static const String done = 'Done';
}
