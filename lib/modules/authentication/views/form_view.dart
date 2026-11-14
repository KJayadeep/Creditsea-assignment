
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/form_controller.dart';
import '../views/email_verification_view.dart';
import '../../../core/widgets/registration_progress.dart';

class FormView extends StatelessWidget {
  const FormView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FormController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Registration progress indicator
            const RegistrationProgress(
                activeStep: 1,
            ),

            // Main form card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
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
                    // Title and back button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        22, 22, 22, 24,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: Get.back,
                            child: const Icon(
                              Icons.arrow_back,
                              size: 23,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF383838),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form fields
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // First name and last name
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('First Name*'),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: controller
                                              .firstNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          validator:
                                              controller.validateName,
                                          decoration: _decoration(
                                            'Your first name',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Last Name*'),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: controller
                                              .lastNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          validator:
                                              controller.validateName,
                                          decoration: _decoration(
                                            'Your last name',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // Gender
                              _label('Gender*'),
                              const SizedBox(height: 10),

                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller
                                          .selectedGender.value.isEmpty
                                      ? null
                                      : controller.selectedGender.value,
                                  isExpanded: true,
                                  decoration: _decoration(
                                    'Select your gender',
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  items: controller.genders.map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(
                                        gender,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedGender.value =
                                        value ?? '';
                                  },
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Date of birth
                              _label('Date of Birth*'),
                              const SizedBox(height: 10),

                              Obx(
                                () => InkWell(
                                  onTap: () => controller
                                      .selectDateOfBirth(context),
                                  child: InputDecorator(
                                    decoration: _decoration(
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
                                        color: controller
                                                    .dateOfBirth.value ==
                                                null
                                            ? Colors.grey.shade500
                                            : AppColors.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Marital status
                              _label('Your Marital Status*'),
                              const SizedBox(height: 10),

                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller
                                          .selectedMaritalStatus.value
                                          .isEmpty
                                      ? null
                                      : controller
                                          .selectedMaritalStatus.value,
                                  isExpanded: true,
                                  decoration: _decoration('Select'),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  items: controller.maritalStatuses
                                      .map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(
                                        status,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedMaritalStatus.value =
                                        value ?? '';
                                  },
                                ),
                              ),

                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Fixed bottom button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24, 12, 24, 24,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.submitDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.action,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: AppColors.action.withValues(
                              alpha: 0.35,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

  static Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF383838),
      ),
    );
  }

  static InputDecoration _decoration(String hint) {
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
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFFEAEAEA),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFFEAEAEA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: AppColors.action,
          width: 1.3,
        ),
      ),
      errorStyle: const TextStyle(fontSize: 10),
    );
  }
}

