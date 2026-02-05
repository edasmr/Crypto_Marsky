import '../data/datasource/crypto_remote_data_source.dart';
import '../entity/crypto_entity.dart';

abstract class CryptoRepository {
  Future<List<Crypto>> fetchCryptos({required int limit, required int offset});
}

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remote;

  CryptoRepositoryImpl(this.remote);

  @override
  Future<List<Crypto>> fetchCryptos({required int limit, required int offset}) {
    return remote.fetchCryptos(limit: limit, offset: offset);
  }
}
