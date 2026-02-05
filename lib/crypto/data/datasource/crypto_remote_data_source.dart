import 'package:dio/dio.dart';

import '../models/crypto_model.dart';

class CryptoRemoteDataSource {
  final Dio dio;

  CryptoRemoteDataSource(this.dio);

  Future<List<CryptoModel>> fetchCryptos({
    required int limit,
    required int offset,
  }) async {
    final response = await dio.get(
      'https://api.coinranking.com/v2/coins',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final List list = response.data['data']['coins'];
    return list.map((e) => CryptoModel.fromJson(e)).toList();
  }
}
