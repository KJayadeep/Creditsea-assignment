
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  static const Duration _animationDuration =
      Duration(milliseconds: 500);

  final List<Map<String, String>> slides = [
    {
      'title': 'Flexible Loan Options',
      'subtitle': 'Loan types to cater to different financial needs',
      'image': 'assets/images/promo-1.svg',
    },
    {
      'title': 'Instant Loan Approval',
      'subtitle': 'Users will receive approval within minutes',
      'image': 'assets/images/promo-2.svg',
    },
    {
      'title': '24×7 Customer Care',
      'subtitle': 'Dedicated customer support team',
      'image': 'assets/images/promo-3.svg',
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
      if (!mounted || !_pageController.hasClients) return;

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
    _autoScrollTimer = null;
  }

  @override
  void dispose() {
    _stopAutoScroll();
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

          // CreditSea logo
          SvgPicture.asset(
            'assets/images/logo-2.svg',
            width: 190,
            height: 45,
            fit: BoxFit.contain,
          ),

          Expanded(
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
                      SizedBox(
                        width: 150,
                        height: 130,
                        child: SvgPicture.asset(
                          slide['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        slide['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          slide['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
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
                  color: currentPage == index
                      ? Colors.white
                      : Colors.white54,
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
