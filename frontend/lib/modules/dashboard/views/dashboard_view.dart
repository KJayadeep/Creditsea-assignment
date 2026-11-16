import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import '../../loan_calculator/views/loan_calculator_view.dart';
import '../../loan_tracking/views/application_status_view.dart';
import '../../profile/views/profile_view.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/loan_overview_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_activity.dart';
import 'widgets/loan_card.dart';
import 'widgets/empty_state.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          switch (controller.selectedIndex.value) {
            case 1:
              return _buildMyLoans();
            case 2:
              return ProfileView();
            default:
              return _buildHome();
          }
        }),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'My Loans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Obx(() {
      final loans = controller.loans.toList();
      final loading = controller.isLoading.value;
      final error = controller.loansError.value;

      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            DashboardHeader(
              userName: controller.userName,
              onProfileTap: () => controller.changeTab(2),
            ),
            const SizedBox(height: 28),
            if (loading && loans.isEmpty)
              const LoanOverviewLoading()
            else if (error.isNotEmpty && loans.isEmpty)
              ErrorState(
                message: error,
                onRetry: controller.fetchLoans,
                dark: true,
              )
            else
              LoanOverviewCard(loan: loans.isEmpty ? null : loans.first),
            const SizedBox(height: 28),
            QuickActions(
              onApply: () => Get.to(() => LoanCalculatorView()),
              onCalculator: () => Get.to(() => LoanCalculatorView()),
              onMyLoans: () => controller.changeTab(1),
            ),
            const SizedBox(height: 28),
            RecentActivity(
              loans: loans.take(3).toList(),
              isLoading: loading,
              error: error,
              onRetry: controller.fetchLoans,
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildMyLoans() {
    return Obx(() {
      final loans = controller.loans.toList();

      if (controller.isLoading.value && loans.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.loansError.value.isNotEmpty && loans.isEmpty) {
        return ErrorState(
          message: controller.loansError.value,
          onRetry: controller.fetchLoans,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/logo-3.svg',
                  height: 34,
                  fit: BoxFit.contain,
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => controller.changeTab(2),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE8EEF5)),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'My Loans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Track all your loan applications',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            if (loans.isEmpty)
              EmptyState(
                title: 'No loan applications yet',
                message: 'Start your first loan application and track its progress here.',
                buttonLabel: 'Apply for Loan',
                onAction: () => Get.to(() => LoanCalculatorView()),
              )
            else ...[
              Text(
                '${loans.length} Application${loans.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ...loans.map(
                (loan) => LoanCard(
                  loan: loan,
                  onViewStatus: () => Get.to(
                    () => ApplicationStatusView(),
                    arguments: loan,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
