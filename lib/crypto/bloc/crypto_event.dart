abstract class CryptoEvent {}

class FetchCryptos extends CryptoEvent {
  final int page;
  final int limit;

  FetchCryptos({this.page = 1, this.limit = 20});
}

class ToggleFavorite extends CryptoEvent {
  final String uuid;

  ToggleFavorite(this.uuid);
}
class LoadFavorites  extends CryptoEvent {
  final String uuid;

  LoadFavorites(this.uuid);
}
class InitFavorites extends CryptoEvent {}
