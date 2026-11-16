import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/components/app_header.dart';
import '../../../core/widgets/registration_progress.dart';
import '../controllers/application_status_controller.dart';
import 'widgets/status_step_card.dart';

class ApplicationStatusView extends StatelessWidget {
  ApplicationStatusView({super.key});

  final ApplicationStatusController controller =
      Get.isRegistered<ApplicationStatusController>()
          ? (Get.find<ApplicationStatusController>()
            ..loadLoanArguments(Get.arguments))
          : Get.put(ApplicationStatusController());

  static const Color blue = Color(0xFF087AFF);
  static const Color green = Color(0xFF00A36C);
  static const Color grey = Color(0xFFB8BEC9);
  static const Color darkText = Color(0xFF383838);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const RegistrationProgress(activeStep: 3),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 15,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          25, 26, 25, 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Page heading with Dashboard quick action
                            AppHeader(
                              title: 'Application Status',
                              fontSize: 24,
                              onBack: () =>
                                  Get.offAllNamed(AppRoutes.dashboard),
                              trailing: IconButton(
                                tooltip: 'Go to Dashboard',
                                icon: const Icon(
                                  Icons.home_outlined,
                                  color: blue,
                                  size: 24,
                                ),
                                onPressed: () =>
                                    Get.offAllNamed(AppRoutes.dashboard),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Obx(
                              () => Text(
                                'Loan application no. #${controller.applicationNumber.value}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: darkText,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Application status timeline
                            Obx(
                              () => Column(
                                children: List.generate(
                                  controller.statuses.length,
                                  (index) {
                                    final isCompleted =
                                        index < controller.currentStatus.value;
                                    final isCurrent =
                                        index == controller.currentStatus.value;

                                    final Color statusColor = isCompleted
                                        ? green
                                        : isCurrent
                                            ? blue
                                            : grey;

                                    return Column(
                                      children: [
                                        StatusStepCard(
                                          title: controller.statuses[index],
                                          color: statusColor,
                                          isCompleted: isCompleted,
                                          isCurrent: isCurrent,
                                          onTap: () {
                                            if (index == 1 &&
                                                controller.currentStatus.value == 1) {
                                              controller.continueFromReview();
                                            } else if (index == 2) {
                                              controller.openAadhaarVerification(context);
                                            } else if (index == 3) {
                                              controller.openENachSetup(context);
                                            } else if (index == 4) {
                                              controller.openESignAgreement(context);
                                            } else if (index == 5) {
                                              controller.openDisbursement(context);
                                            }
                                          },
                                        ),

                                        if (index !=
                                            controller.statuses.length - 1)
                                          Container(
                                            width: 1.5,
                                            height: 18,
                                            color: index <
                                                    controller.currentStatus.value
                                                ? green
                                                : const Color(0xFFB8BEC9),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),

                            // 1. Review countdown banner (when in Step 1)
                            Obx(() {
                              if (controller.currentStatus.value == 1) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F7FF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFCCE4FF),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            color: blue,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 10),
                                          const Expanded(
                                            child: Text(
                                              'Review in Progress',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: blue,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: blue,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              controller.formattedReviewTime,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: (120 -
                                                  controller
                                                      .reviewRemainingSeconds
                                                      .value) /
                                              120,
                                          backgroundColor:
                                              const Color(0xFFD6E9FF),
                                          valueColor:
                                              const AlwaysStoppedAnimation<Color>(
                                            blue,
                                          ),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // 2. E-KYC interactive banner (when in Step 2)
                            Obx(() {
                              if (controller.currentStatus.value == 2) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F8F3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFB5EAD7),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => controller
                                        .openAadhaarVerification(context),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.fingerprint,
                                          color: green,
                                          size: 28,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tap here to verify Aadhaar e-KYC',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0D5E42),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Instant paperless identity verification',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF1B8A62),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: green,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // 3. E-Nach interactive banner (when in Step 3)
                            Obx(() {
                              if (controller.currentStatus.value == 3) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F7FF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFCCE4FF),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        controller.openENachSetup(context),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance,
                                          color: blue,
                                          size: 26,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Set Up Auto-Debit on Due Date',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: blue,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Powered by Razorpay e-Mandate / UPI AutoPay',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF5582AA),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // 4. E-Sign interactive banner (when in Step 4)
                            Obx(() {
                              if (controller.currentStatus.value == 4) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDF6E2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFBE2A4),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        controller.openESignAgreement(context),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.draw_outlined,
                                          color: Color(0xFFB28100),
                                          size: 26,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'E-Sign Loan Agreement Consent',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF7A5800),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Review contract terms and provide digital consent',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF946F00),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: Color(0xFFB28100),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // 5. Disbursement interactive banner (when in Step 5)
                            Obx(() {
                              if (controller.currentStatus.value == 5) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F8F3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFB5EAD7),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        controller.openDisbursement(context),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.payments_outlined,
                                          color: green,
                                          size: 26,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ready for Instant Disbursement',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0D5E42),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Tap to credit funds directly to your bank account',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF1B8A62),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: green,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            const SizedBox(height: 32),

                            // Current status illustration
                            Center(
                              child: Obx(
                                () => Icon(
                                  _statusIcon(
                                    controller.currentStatus.value,
                                  ),
                                  size: 62,
                                  color: controller.currentStatus.value >= 5
                                      ? green
                                      : blue,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Current status title
                            Center(
                              child: Obx(
                                () => Text(
                                  controller.statusTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Current status description
                            Center(
                              child: Obx(
                                () => Text(
                                  controller.statusDescription,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                    color: darkText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        25, 12, 25, 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            if (controller.isRejected) {
                              return const SizedBox.shrink();
                            }

                            String buttonText = 'Continue';
                            IconData buttonIcon = Icons.arrow_forward;
                            Color buttonColor = blue;

                            if (controller.isRepaid) {
                              buttonText = 'Apply for a New Loan';
                              buttonIcon = Icons.add_circle_outline;
                              buttonColor = green;
                            } else if (controller.currentStatus.value == 1) {
                              buttonText =
                                  'Continue (Skip Wait ${controller.formattedReviewTime})';
                              buttonIcon = Icons.fast_forward;
                            } else if (controller.currentStatus.value == 2) {
                              buttonText = 'Complete E-KYC (Aadhaar)';
                              buttonIcon = Icons.fingerprint;
                              buttonColor = blue;
                            } else if (controller.currentStatus.value == 3) {
                              buttonText = 'Set Up Auto-Debit (E-Nach)';
                              buttonIcon = Icons.account_balance;
                              buttonColor = blue;
                            } else if (controller.currentStatus.value == 4) {
                              buttonText = 'Review & E-Sign Agreement';
                              buttonIcon = Icons.draw;
                              buttonColor = blue;
                            } else if (controller.currentStatus.value == 5) {
                              buttonText = 'Instant Loan Disbursement';
                              buttonIcon = Icons.payments;
                              buttonColor = green;
                            } else {
                              buttonText = 'Proceed to Loan Repayment';
                              buttonIcon = Icons.check_circle_outline;
                              buttonColor = green;
                            }

                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller
                                        .handlePrimaryAction(context),
                                    icon: Icon(buttonIcon, size: 20),
                                    label: Text(
                                      buttonText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor:
                                          buttonColor.withValues(alpha: 0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(9),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Get.offAllNamed(AppRoutes.dashboard);
                              },
                              icon: const Icon(
                                Icons.dashboard_outlined,
                                size: 19,
                              ),
                              label: const Text(
                                'Go to Dashboard',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: blue,
                                side: const BorderSide(
                                  color: blue,
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  IconData _statusIcon(int status) {
    if (controller.isRepaid) {
      return Icons.verified;
    }
    switch (status) {
      case 0:
        return Icons.assignment_turned_in_outlined;
      case 1:
        return Icons.timer_outlined;
      case 2:
        return Icons.fingerprint;
      case 3:
        return Icons.account_balance_outlined;
      case 4:
        return Icons.draw_outlined;
      case 5:
        return Icons.payments_outlined;
      case 6:
        return Icons.check_circle_outline;
      default:
        return Icons.assignment_outlined;
    }
  }
}
