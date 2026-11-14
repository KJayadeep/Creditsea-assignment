import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import '../views/otp_view.dart';

class SignupController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool acceptedTerms = true.obs;

  void toggleTerms(bool value) {
    acceptedTerms.value = value;
  }

  void requestOtp() {
  if (!formKey.currentState!.validate()) {
    return;
  }

  if (!acceptedTerms.value) {
    Get.snackbar(
      'Terms required',
      'Please accept the privacy policy and terms.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  final phone = phoneController.text.trim();

  Get.to(
    () => const OtpView(),
    arguments: {
      'phone': phone,
    },
    transition: Transition.rightToLeft,
  );
}

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}