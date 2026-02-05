import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../crypto/bloc/crypto_bloc.dart';
import '../crypto/bloc/crypto_event.dart';
import '../crypto/bloc/crypto_state.dart';

class FavoritesPage extends StatelessWidget {
  final CryptoBloc bloc;

  const FavoritesPage({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<CryptoBloc, CryptoState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is CryptoLoaded) {
              final favorites = state.cryptos
                  .where((c) => state.favorites.contains(c.uuid))
                  .toList();
              if (favorites.isEmpty) {
                return Center(child: Text('No favorites yet'));
              }
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final crypto = favorites[index];
                  return ListTile(
                    leading: Image.network(
                      crypto.iconUrl,
                      width: 32,
                      height: 32,
                      errorBuilder: (c, e, s) =>
                          Icon(Icons.monetization_on, size: 32,
                              color: Colors.grey),
                    ),
                    title: Text('${crypto.name} (${crypto.symbol})'),
                    subtitle: Text(
                        'Price: \$${crypto.price}\nChange: ${crypto
                            .change}%\nRank: ${crypto.rank}'),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.black),
                      onPressed: () => bloc.add(ToggleFavorite(crypto.uuid)),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
    );
    }
}
