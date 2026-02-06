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
class NetworkException {
  static String getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please try again.';

        case DioExceptionType.sendTimeout:
          return 'Request timeout. Please try again.';

        case DioExceptionType.receiveTimeout:
          return 'Server is taking too long to respond.';

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;

          if (statusCode == 401) {
            return 'Unauthorized request.';
          } else if (statusCode == 404) {
            return 'Requested data not found.';
          } else if (statusCode != null && statusCode >= 500) {
            return 'Server error. Please try later.';
          }

          return 'Something went wrong.';

        case DioExceptionType.connectionError:
          return 'No internet connection.';

        default:
          return 'Unexpected error occurred.';
      }
    }

    return 'Something went wrong.';
  }
}

