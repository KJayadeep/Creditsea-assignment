
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  // Send OTP
  Future<Response> sendOTP(String phone) async {
    return await _dio.post(
      '/auth/send-otp',
      data: {
        'phone': phone,
      },
    );
  }

  // Verify OTP
  Future<Response> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    return await _dio.post(
      '/auth/verify-otp',
      data: {
        'phone': phone,
        'otp': otp,
      },
    );
  }

  // Register
  Future<Response> register({
    required String phone,
    required String password,
  }) async {
    return await _dio.post(
      '/auth/register',
      data: {
        'phone': phone,
        'password': password,
      },
    );
  }

  // Login
  Future<Response> login({
    required String phone,
    required String password,
  }) async {
    return await _dio.post(
      '/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    );
  }

  // Logout
  Future<Response> logout() async {
    return await _dio.post('/auth/logout');
  }
}
