
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/registration_progress.dart';
import '../controllers/application_status_controller.dart';

class ApplicationStatusView extends StatelessWidget {
  ApplicationStatusView({super.key});

  final ApplicationStatusController controller =
      Get.put(ApplicationStatusController());

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
                            // Page heading
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: darkText,
                                  ),
                                ),
                                const SizedBox(width: 22),
                                const Text(
                                  'Application Status',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Loan application no. #${controller.applicationNumber}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: darkText,
                              ),
                            ),

                            const SizedBox(height: 34),

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
                                        _statusCard(
                                          title: controller.statuses[index],
                                          color: statusColor,
                                          isCompleted: isCompleted,
                                          isCurrent: isCurrent,
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

                            const SizedBox(height: 40),

                            // Current status illustration
                            Center(
                              child: Obx(
                                () => Icon(
                                  _statusIcon(
                                    controller.currentStatus.value,
                                  ),
                                  size: 62,
                                  color: blue,
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

                    // Bottom Continue button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        33, 12, 33, 77,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 66,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.snackbar(
                              'Application Status',
                              'Your application is currently under review.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: blue.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
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

Widget _statusCard({
  required String title,
  required Color color,
  required bool isCompleted,
  required bool isCurrent,
}) {
  return Container(
    width: double.infinity,
    height: 46,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: color,
        width: 1.8,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Row(
      children: [
        const SizedBox(width: 16),

        Icon(
          isCompleted
              ? Icons.assignment_turned_in_outlined
              : Icons.assignment_outlined,
          color: color,
          size: 23,
        ),

        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: 30),
      ],
    ),
  );
}

  IconData _statusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.assignment_turned_in_outlined;
      case 1:
        return Icons.credit_card_outlined;
      case 2:
        return Icons.verified_user_outlined;
      case 3:
        return Icons.account_balance_outlined;
      case 4:
        return Icons.draw_outlined;
      case 5:
        return Icons.payments_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }
}
