import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class UserRepository {
  final Dio _dio = ApiClient.dio;

  // Fetch logged-in user's profile
  Future<Response> getProfile() async {
    return await _dio.get('/users/profile');
  }

  // Update user profile
  Future<Response> updateProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required String maritalStatus,
    String? email,
  }) async {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'maritalStatus': maritalStatus,
    };
    if (email != null && email.isNotEmpty) {
      data['email'] = email;
    }
    return await _dio.put(
      '/users/profile',
      data: data,
    );
  }

  // Verify email address
  Future<Response> verifyEmail({
    required String email,
  }) async {
    return await _dio.put(
      '/users/verify-email',
      data: {
        'email': email,
      },
    );
  }

  // Verify PAN number
  Future<Response> verifyPAN({
    required String panNumber,
  }) async {
    return await _dio.put(
      '/users/verify-pan',
      data: {
        'panNumber': panNumber,
      },
    );
  }

  // Verify Aadhaar number
  Future<Response> verifyAadhaar({
    required String aadhaarNumber,
  }) async {
    return await _dio.put(
      '/users/verify-aadhaar',
      data: {
        'aadhaarNumber': aadhaarNumber,
      },
    );
  }
}
