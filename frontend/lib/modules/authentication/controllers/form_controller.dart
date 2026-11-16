import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../data/repositories/user_repository.dart';
import '../views/email_verification_view.dart';

class FormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  final RxString selectedGender = ''.obs;
  final RxString selectedMaritalStatus = ''.obs;
  final Rxn<DateTime> dateOfBirth = Rxn<DateTime>();

  final RxBool isLoading = false.obs;
  final RxBool isFetchingProfile = false.obs;

  final List<String> genders = [
    'Male',
    'Female',
    'Other',
  ];

  final List<String> maritalStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  @override
  void onInit() {
    super.onInit();
    loadExistingProfile();
  }

  Future<void> loadExistingProfile() async {
    try {
      isFetchingProfile.value = true;
      final response = await _userRepository.getProfile();
      final data = response.data;

      if (data is Map && data['user'] is Map) {
        final user = data['user'] as Map;
        final fn = user['firstName']?.toString() ?? '';
        final ln = user['lastName']?.toString() ?? '';
        final gen = user['gender']?.toString() ?? '';
        final ms = user['maritalStatus']?.toString() ?? '';
        final dobStr = user['dateOfBirth']?.toString();

        if (fn.isNotEmpty) firstNameController.text = fn;
        if (ln.isNotEmpty) lastNameController.text = ln;
        if (genders.contains(gen)) selectedGender.value = gen;
        if (maritalStatuses.contains(ms)) selectedMaritalStatus.value = ms;

        if (dobStr != null && dobStr.isNotEmpty) {
          final parsed = DateTime.tryParse(dobStr);
          if (parsed != null) {
            dateOfBirth.value = parsed;
          }
        }
      }
    } catch (_) {
      // Quietly ignore if not authenticated or initial profile doesn't exist yet
    } finally {
      isFetchingProfile.value = false;
    }
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final today = DateTime.now();
    final maxDate = DateTime(today.year - 18, today.month, today.day);
    final minDate = DateTime(1940);

    DateTime initial = dateOfBirth.value ?? DateTime(today.year - 25, today.month, today.day);
    if (initial.isAfter(maxDate)) initial = maxDate;
    if (initial.isBefore(minDate)) initial = minDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: minDate,
      lastDate: maxDate,
      helpText: 'Select your date of birth (18+ only)',
    );

    if (picked != null) {
      dateOfBirth.value = picked;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Must be at least 2 characters';
    }

    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(trimmed)) {
      return 'Enter a valid name';
    }

    return null;
  }

  Future<void> submitDetails() async {
    if (isLoading.value) return;

    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar('Required', 'Please select your gender');
      return;
    }

    if (dateOfBirth.value == null) {
      Get.snackbar('Required', 'Please select your date of birth');
      return;
    }

    if (selectedMaritalStatus.value.isEmpty) {
      Get.snackbar('Required', 'Please select marital status');
      return;
    }

    isLoading.value = true;

    try {
      final dob = dateOfBirth.value!;

      final response = await _userRepository.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        dateOfBirth:
            '${dob.year.toString().padLeft(4, '0')}-'
            '${dob.month.toString().padLeft(2, '0')}-'
            '${dob.day.toString().padLeft(2, '0')}',
        gender: selectedGender.value,
        maritalStatus: selectedMaritalStatus.value,
      );

      Get.snackbar(
        'Success',
        response.data['message'] ?? 'Personal details saved',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.to(() => EmailVerificationView());
    } on DioException catch (error) {
      final data = error.response?.data;

      Get.snackbar(
        'Error',
        data is Map
            ? data['message']?.toString() ?? 'Failed to save details'
            : 'Failed to save personal details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM);
      debugPrint('Profile update error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
