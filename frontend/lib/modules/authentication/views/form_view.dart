import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/components/app_header.dart';
import '../../../core/components/custom_text_input.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/registration_progress.dart';
import '../controllers/form_controller.dart';

class FormView extends StatelessWidget {
  const FormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FormController>()
        ? Get.find<FormController>()
        : Get.put(FormController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const RegistrationProgress(activeStep: 1),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 22, 22, 16),
                      child: AppHeader(title: 'Personal Details'),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CustomTextInput(
                                      label: 'First Name*',
                                      hintText: 'Your first name',
                                      controller: controller.firstNameController,
                                      textCapitalization: TextCapitalization.words,
                                      validator: controller.validateName,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: CustomTextInput(
                                      label: 'Last Name*',
                                      hintText: 'Your last name',
                                      controller: controller.lastNameController,
                                      textCapitalization: TextCapitalization.words,
                                      validator: controller.validateName,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Gender*',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF383838),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller.selectedGender.value.isEmpty
                                      ? null
                                      : controller.selectedGender.value,
                                  isExpanded: true,
                                  decoration: _dropdownDecoration(
                                    'Select your gender',
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: controller.genders.map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(
                                        gender,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedGender.value =
                                        value ?? '';
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Date of Birth*',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF383838),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => InkWell(
                                  onTap: () =>
                                      controller.selectDateOfBirth(context),
                                  child: InputDecorator(
                                    decoration: _dropdownDecoration(
                                      'DD - MM - YYYY',
                                    ).copyWith(
                                      suffixIcon: const Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                      ),
                                    ),
                                    child: Text(
                                      controller.dateOfBirth.value == null
                                          ? 'DD - MM - YYYY'
                                          : DateFormat('dd - MM - yyyy')
                                              .format(
                                              controller.dateOfBirth.value!,
                                            ),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:
                                            controller.dateOfBirth.value == null
                                                ? Colors.grey.shade500
                                                : AppColors.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Your Marital Status*',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF383838),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller
                                          .selectedMaritalStatus.value.isEmpty
                                      ? null
                                      : controller.selectedMaritalStatus.value,
                                  isExpanded: true,
                                  decoration: _dropdownDecoration('Select'),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: controller.maritalStatuses.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(
                                        status,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedMaritalStatus.value =
                                        value ?? '';
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Obx(
                        () => PrimaryButton(
                          text: 'Continue',
                          height: 50,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.submitDetails,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.action, width: 1.3),
      ),
    );
  }
}
