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
    return BlocConsumer<AuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is RegisteredSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text(AuthGateStrings.success),
              content: const Text(AuthGateStrings.emailField),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(AuthGateStrings.done),
                ),
              ],
            ),
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {

        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is Authenticated) {
          return const MainScaffold();
        }

        return const LoginPage();
      },
    );
  }
}

class AuthGateStrings {
  static const String success = 'Successful';
  static const String emailField = 'Registration successfully created.\nYou can now log in.';
  static const String done = 'Done';
}
