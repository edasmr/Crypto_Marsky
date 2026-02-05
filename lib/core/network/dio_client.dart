import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: "https://api.coinranking.com/v2",
          headers: {
            "x-access-token":
                "coinrankinge715762e4f2f0fcd34a17d5779476ea17fcbb836d77a4589",
          },
        ),
      );
}
