import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/loan_repository.dart';

class DashboardController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final LoanRepository _loanRepository = LoanRepository();
  final AuthRepository _authRepository = AuthRepository();

  final selectedIndex = 0.obs;
  final isLoading = false.obs;
  final isLoggingOut = false.obs;

  final profile = <String, dynamic>{}.obs;
  final loans = <Map<String, dynamic>>[].obs;

  final profileError = ''.obs;
  final loansError = ''.obs;

  String get userName {
    final firstName = profile['firstName']?.toString() ?? '';
    final lastName = profile['lastName']?.toString() ?? '';

    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'there' : fullName;
  }

  Map<String, dynamic>? get latestLoan {
    if (loans.isEmpty) return null;
    return loans.first;
  }

  String get loanStatus {
    return latestLoan?['status']?.toString() ?? 'No active loan';
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> loadDashboard() async {
    if (isLoading.value) return;

    isLoading.value = true;

    await Future.wait([
      fetchProfile(),
      fetchLoans(),
    ]);

    isLoading.value = false;
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _userRepository.getProfile();
      final data = response.data;

      if (data is Map && data['user'] is Map) {
        profile.assignAll(
          Map<String, dynamic>.from(data['user']),
        );
      }

      profileError.value = '';
    } on DioException catch (error) {
      profileError.value = _getErrorMessage(
        error,
        'Unable to load profile',
      );
    } catch (_) {
      profileError.value = 'Unable to load profile';
    }
  }

  Future<void> fetchLoans() async {
    try {
      final response = await _loanRepository.getMyLoans();
      final data = response.data;

      if (data is Map && data['loans'] is List) {
        loans.assignAll(
          (data['loans'] as List)
              .whereType<Map>()
              .map((loan) => Map<String, dynamic>.from(loan))
              .toList(),
        );
      }

      loansError.value = '';
    } on DioException catch (error) {
      loansError.value = _getErrorMessage(
        error,
        'Unable to load loans',
      );
    } catch (_) {
      loansError.value = 'Unable to load loans';
    }
  }

  String _getErrorMessage(
    DioException error,
    String fallback,
  ) {
    final data = error.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    return fallback;
  }

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF78838F), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoggingOut.value = true;
    try {
      try {
        await _authRepository.logout();
      } catch (_) {
        // Proceed with local logout even if remote server is unreachable
      }

      final storageService = Get.find<StorageService>();
      await storageService.clearAuth();

      profile.clear();
      loans.clear();

      Get.offAllNamed(AppRoutes.signin);

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      isLoggingOut.value = false;
    }
  }
}
