import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/email_verification_view.dart';

class FormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedMaritalStatus = ''.obs;
  final Rxn<DateTime> dateOfBirth = Rxn<DateTime>();

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

  Future<void> selectDateOfBirth(BuildContext context) async {
    final today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 25),
      firstDate: DateTime(1940),
      lastDate: today,
      helpText: 'Select your date of birth',
    );

    if (picked != null) {
      dateOfBirth.value = picked;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value.trim())) {
      return 'Enter a valid name';
    }

    return null;
  }

void submitDetails() {
  if (!formKey.currentState!.validate()) return;

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

  Get.to(() => EmailVerificationView());
}

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}