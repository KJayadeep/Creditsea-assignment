import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import 'widgets/profile_info_card.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final DashboardController controller =
      Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController());

  static const Color primary = Color(0xFF175397);
  static const Color background = Color(0xFFF5F6F8);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF78838F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Obx(() {
          final profile = controller.profile;

          return RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            color: primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Manage your personal information',
                          style: TextStyle(
                            fontSize: 13,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Log Out',
                      onPressed: controller.logout,
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFD32F2F),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Header Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 42,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        controller.userName == 'there'
                            ? 'CreditSea User'
                            : controller.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        profile['phone']?.toString() ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 12),

                ProfileInfoCard(
                  fields: [
                    ProfileFieldItem(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: controller.userName == 'there'
                          ? 'Not provided'
                          : controller.userName,
                    ),
                    ProfileFieldItem(
                      icon: Icons.cake_outlined,
                      label: 'Date of Birth',
                      value: _formatDate(profile['dateOfBirth']),
                    ),
                    ProfileFieldItem(
                      icon: Icons.wc_outlined,
                      label: 'Gender',
                      value: profile['gender']?.toString(),
                    ),
                    ProfileFieldItem(
                      icon: Icons.favorite_outline,
                      label: 'Marital Status',
                      value: profile['maritalStatus']?.toString(),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Verification Status',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 12),

                ProfileInfoCard(
                  fields: [
                    ProfileFieldItem(
                      icon: Icons.phone_android_outlined,
                      label: 'Mobile Number',
                      value: profile['phone']?.toString(),
                    ),
                    ProfileFieldItem(
                      icon: Icons.email_outlined,
                      label: 'Email ID',
                      value: profile['email']?.toString(),
                    ),
                    ProfileFieldItem(
                      icon: Icons.credit_card_outlined,
                      label: 'PAN Number',
                      value: profile['panNumber']?.toString(),
                    ),
                    ProfileFieldItem(
                      icon: Icons.verified_user_outlined,
                      label: 'PAN Verification',
                      value: profile['panVerified'] == true
                          ? 'Verified'
                          : 'Pending',
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Logout Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoggingOut.value
                          ? null
                          : controller.logout,
                      icon: controller.isLoggingOut.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFD32F2F),
                              ),
                            )
                          : const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFD32F2F),
                              size: 20,
                            ),
                      label: Text(
                        controller.isLoggingOut.value
                            ? 'Logging out...'
                            : 'Log Out',
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        side: const BorderSide(
                          color: Color(0xFFFFCDD2),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'Not provided';
    final date = DateTime.tryParse(value.toString());
    if (date == null) return value.toString();

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
