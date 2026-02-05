import 'package:crypto_marsky/features/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(LoginStrings.logo),
            const SizedBox(height: 8),
            const Text(
              LoginStrings.welcomeText,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: LoginStrings.emailField,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: LoginStrings.passwordField,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                print("LOGIN CLICKED");
                context.read<AuthBloc>().add(
                  LoginRequested(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  ),
                );
              },
              child: const Text(LoginStrings.loginButton),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text(LoginStrings.registerButton),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginStrings {
  static const String welcomeText = 'Welcome Crypto 👋';
  static const String emailField = 'Email';
  static const String passwordField = 'Password';
  static const String loginButton = 'Login';
  static const String registerButton = 'Don’t have an account? Register';
  static const logo = 'assets/images/crypto_icon.png';
  static const logo2 = 'assets/images/cryptocurrencies.png';

}
