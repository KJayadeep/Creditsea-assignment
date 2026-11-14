import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PromoHeader extends StatefulWidget {
  const PromoHeader({super.key});

  @override
  State<PromoHeader> createState() => _PromoHeaderState();
}

class _PromoHeaderState extends State<PromoHeader> {
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int currentPage = 0;

  static const Duration _autoScrollInterval = Duration(seconds: 3);
  static const Duration _animationDuration = Duration(milliseconds: 500);

  final List<Map<String, dynamic>> slides = [
    {
      'title': 'Flexible Loan Options',
      'subtitle': 'Loan types to cater to different financial needs',
      'icon': Icons.directions_car_outlined,
    },
    {
      'title': 'Instant Loan Approval',
      'subtitle': 'Users will receive approval within minutes',
      'icon': Icons.description_outlined,
    },
    {
      'title': '24×7 Customer Care',
      'subtitle': 'Dedicated customer support team',
      'icon': Icons.support_agent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(_autoScrollInterval, (_) {
      if (!_pageController.hasClients) return;

      final nextPage = (currentPage + 1) % slides.length;

      _pageController.animateToPage(
        nextPage,
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Column(
        children: [
          const SizedBox(height: 24),

          // CreditSea logo placeholder
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bolt,
                color: AppColors.accent,
                size: 35,
              ),
              SizedBox(width: 5),
              Text(
                'CreditSea',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          Expanded(
            // Pause auto-scroll while the user is touching/dragging,
            // resume when they let go.
            child: Listener(
              onPointerDown: (_) => _stopAutoScroll(),
              onPointerUp: (_) => _startAutoScroll(),
              onPointerCancel: (_) => _startAutoScroll(),
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          slide['icon'] as IconData,
                          size: 65,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        slide['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        slide['subtitle'] as String,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentPage == index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}