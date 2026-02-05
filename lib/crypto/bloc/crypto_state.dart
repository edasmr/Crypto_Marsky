import '../data/models/crypto_model.dart';

abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<CryptoModel> cryptos;
  final List<String> favorites;

  CryptoLoaded(this.cryptos, this.favorites);
}

class CryptoError extends CryptoState {
  final String message;

  CryptoError(this.message);
}
