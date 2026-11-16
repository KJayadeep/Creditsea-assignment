import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../network/api_client.dart';

class StorageService extends GetxService {
  late final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _phoneKey = 'user_phone';

  Future<StorageService> init() async {
    _storage = const FlutterSecureStorage();

    final savedToken = await _storage.read(key: _tokenKey);
    if (savedToken != null && savedToken.isNotEmpty) {
      ApiClient.authToken = savedToken;
    }

    return this;
  }

  Future<void> saveToken(String token) async {
    ApiClient.authToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> savePhone(String phone) async {
    await _storage.write(key: _phoneKey, value: phone);
  }

  Future<String?> getPhone() async {
    return await _storage.read(key: _phoneKey);
  }

  Future<void> saveLoanProgress(String appNumber, int step) async {
    await _storage.write(key: 'loan_step_$appNumber', value: step.toString());
  }

  Future<int?> getLoanProgress(String appNumber) async {
    final val = await _storage.read(key: 'loan_step_$appNumber');
    return val != null ? int.tryParse(val) : null;
  }

  Future<void> clearAuth() async {
    ApiClient.authToken = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _phoneKey);
  }

  bool get isAuthenticated =>
      ApiClient.authToken != null && ApiClient.authToken!.isNotEmpty;
}
