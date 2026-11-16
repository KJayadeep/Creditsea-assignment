import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (Get.isRegistered<StorageService>() &&
          Get.find<StorageService>().isAuthenticated) {
        Get.offNamed(AppRoutes.dashboard);
      } else {
        Get.offNamed(AppRoutes.signup);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/Creditsea_logo.svg',
          width: 190,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
