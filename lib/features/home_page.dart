import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../crypto/bloc/crypto_bloc.dart';
import '../crypto/bloc/crypto_event.dart';
import '../crypto/bloc/crypto_state.dart';

class HomePage extends StatefulWidget {
  final CryptoBloc bloc;
  const HomePage({required this.bloc, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.bloc.add(FetchCryptos(page: page, limit: limit));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        widget.bloc.add(FetchCryptos(page: page, limit: limit));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CryptoBloc, CryptoState>(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is CryptoLoading && page == 1) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CryptoLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.cryptos.length,
              itemBuilder: (context, index) {
                final crypto = state.cryptos[index];
                final isFav = state.favorites.contains(crypto.uuid);

                return ListTile(
                  leading: Image.network(
                    crypto.iconUrl,
                    width: 32,
                    height: 32,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 32,
                        height: 32,
                        child:
                        Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.monetization_on,
                          size: 32, color: Colors.grey);
                    },
                  ),
                  title: Text('${crypto.name} (${crypto.symbol})'),
                  subtitle: Text(
                      'Price: \$${crypto.price.toStringAsFixed(2)}\nChange: ${crypto.change.toStringAsFixed(2)}%\nRank: ${crypto.rank}'),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.black : null,
                    ),
                    onPressed: () =>
                        widget.bloc.add(ToggleFavorite(crypto.uuid)),
                  ),
                );
              },
            );
          } else if (state is CryptoError) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
    );
  }
}
