import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../data/models/crypto_model.dart';
import '../repo/crypto_repository.dart';
import 'crypto_event.dart';
import 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepositoryImpl repository;
  final Box<String> favoritesBox = Hive.box<String>('favorites');

  CryptoBloc(this.repository) : super(CryptoInitial()) {
    on<FetchCryptos>((event, emit) async {
      emit(CryptoLoading());
      try {
        final cryptos = await repository.fetchCryptos(limit: 20, offset: 0);
        final favorite = favoritesBox.values.toList();
        emit(CryptoLoaded(cryptos.cast<CryptoModel>(), favorite));
      } catch (e) {
        emit(CryptoError(e.toString()));
      }
    });

    on<ToggleFavorite>((event, emit) {
      final currentFavorite = favoritesBox.values.toList();
      if (currentFavorite.contains(event.uuid)) {
        final key = favoritesBox.keys.firstWhere(
          (k) => favoritesBox.get(k) == event.uuid,
          orElse: () => null,
        );
        if (key != null) favoritesBox.delete(key);
      } else {
        favoritesBox.add(event.uuid);
      }
      if (state is CryptoLoaded) {
        emit(
          CryptoLoaded(
            (state as CryptoLoaded).cryptos,
            favoritesBox.values.toList(),
          ),
        );
      }
    });
  }
}
