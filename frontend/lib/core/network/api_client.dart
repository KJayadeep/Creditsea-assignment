import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'browser_adapter_stub.dart'
    if (dart.library.js_interop) 'browser_adapter_web.dart'
    if (dart.library.html) 'browser_adapter_web.dart';

class ApiClient {
  static String? authToken;

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
  );

  static void initialize() {
    if (kIsWeb) {
      configureBrowserAdapter(dio);
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (authToken != null && authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }
          return handler.next(options);
        },
      ),
    );

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
