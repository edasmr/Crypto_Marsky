import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../data/models/crypto_model.dart';
import '../repo/crypto_repository.dart';
import 'crypto_event.dart';
import 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepositoryImpl repository;
  final String userId;

  late final Box<String> favoritesBox;

  CryptoBloc(this.repository, this.userId) : super(CryptoInitial()) {
    _initFavorites();

    on<FetchCryptos>(_onFetchCryptos);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _initFavorites() async {
    favoritesBox = await Hive.openBox<String>('favorites_$userId');
  }

  Future<void> _onFetchCryptos(
      FetchCryptos event,
      Emitter<CryptoState> emit,
      ) async {
    emit(CryptoLoading());
    try {
      final cryptos =
      await repository.fetchCryptos(limit: 20, offset: 0);

      final favorites = favoritesBox.values.toList();

      emit(
        CryptoLoaded(
          cryptos.cast<CryptoModel>(),
          favorites,
        ),
      );
    } catch (e) {
      emit(CryptoError(e.toString()));
    }
  }

  void _onToggleFavorite(
      ToggleFavorite event,
      Emitter<CryptoState> emit,
      ) {
    final currentFavorites = favoritesBox.values.toList();

    if (currentFavorites.contains(event.uuid)) {
      final key = favoritesBox.keys.firstWhere(
            (k) => favoritesBox.get(k) == event.uuid,
        orElse: () => null,
      );
      if (key != null) {
        favoritesBox.delete(key);
      }
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
  }
}
