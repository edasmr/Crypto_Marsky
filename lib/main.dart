import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_gate.dart';
import 'auth/auth_repository.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('favorites');
  await Supabase.initialize(
    url: 'https://ddfghbydzpdksanwwfnl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkZmdoYnlkenBka3Nhbnd3Zm5sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAxMzQ3MTgsImV4cCI6MjA4NTcxMDcxOH0.GbjYdaNVO5dh9oliK3QkR8-1wyhhza3_-eHA5dZFtkE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository())..add(AppStarted()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    );
  }
}
