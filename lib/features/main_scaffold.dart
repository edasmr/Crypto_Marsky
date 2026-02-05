import 'package:crypto_marsky/crypto/bloc/crypto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../core/network/dio_client.dart';
import '../crypto/bloc/crypto_event.dart';
import '../crypto/data/datasource/crypto_remote_data_source.dart';
import '../crypto/repo/crypto_repository.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  late final DioClient dioClient;
  late final CryptoRemoteDataSource remote;
  late final CryptoRepositoryImpl repository;
  CryptoBloc? cryptoBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authState = context.read<AuthBloc>().state;

    if (authState is Authenticated) {
      final userId = authState.user.id;

      dioClient = DioClient();
      remote = CryptoRemoteDataSource(dioClient.dio);
      repository = CryptoRepositoryImpl(remote);

      cryptoBloc ??= CryptoBloc(repository, userId)..add(FetchCryptos());
    }
  }

  @override
  void dispose() {
    cryptoBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cryptoBloc!,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _currentIndex == 0 ? MainStrings.crypto : MainStrings.favorites,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          actions: _currentIndex == 0
              ? [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.black,
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ]
              : null,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(bloc: cryptoBloc!),
            FavoritesPage(bloc: cryptoBloc!),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: MainStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: MainStrings.favorites,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(MainStrings.logOut),
        content: const Text(MainStrings.checkLogOut),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(MainStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text(MainStrings.yes),
          ),
        ],
      ),
    );
  }
}

class MainStrings {
  static const String home = 'Home';
  static const String logOut = 'Logout';
  static const String checkLogOut = 'Are you sure you want to log out?';
  static const String cancel = 'Cancel';
  static const String crypto = 'Crypto';
  static const String favorites = 'Favorites';
  static const String yes = 'Yes';
}
