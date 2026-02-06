import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/crypto_model.dart';

class CryptoRemoteDataSource {
  final Dio dio;

  CryptoRemoteDataSource(this.dio);

  Future<List<CryptoModel>> fetchCryptos({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await dio.get(
        '/coins',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      final List list = response.data['data']['coins'];

      return list.map((e) => CryptoModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(NetworkException.getErrorMessage(e));
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }
}
