import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is RegisteredSuccess) {
          _showSuccessDialog();
        }

        if (state is AuthError) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(RegisterStrings.register)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(LoginStrings.logo,height: 300),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: RegisterStrings.email),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: RegisterStrings.password),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onRegisterPressed,
                child: const Text(RegisterStrings.register),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRegisterPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError(RegisterStrings.notEmptyMessage);
      return;
    }

    if (password.length < 6) {
      _showError(RegisterStrings.characterLimit);
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(email, password),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(RegisterStrings.success),
        content: const Text(RegisterStrings.successInfo),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(RegisterStrings.done),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

}
class RegisterStrings {
  static const String success = 'Successful';
  static const String successInfo = 'Registration successfully created.\nYou can now log in.';
  static const String register = 'Register';
  static const String done = 'Done';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String notEmptyMessage = 'Email and password cannot be blank.';
  static const String characterLimit = 'The password must be at least 6 characters long.';
}

