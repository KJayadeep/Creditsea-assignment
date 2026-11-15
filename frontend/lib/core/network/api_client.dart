
import 'package:dio/dio.dart';
import 'package:dio/browser.dart';

class ApiClient {
  static final BrowserHttpClientAdapter _browserAdapter =
      BrowserHttpClientAdapter()
        ..withCredentials = true;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8000/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..httpClientAdapter = _browserAdapter;

  static void initialize() {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
      ),
    );
  }
}
