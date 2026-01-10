import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/constants/app_data.dart';
import 'package:rightlogistics/src/core/presentation/widgets/gradient_button.dart';
import 'package:rightlogistics/src/core/services/persistence_service.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/core/services/permission_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = AppData.services
      .take(3)
      .map(
        (s) => OnboardingData(
          title: s['title'] as String,
          description: s['description'] as String,
          icon: s['icon'] as IconData,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemBuilder: (context, index) =>
                _OnboardingPage(data: _pages[index]),
          ),
          Positioned(
            bottom: 64.h,
            left: 24.w,
            right: 24.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildIndicator(index == _currentPage, theme),
                  ),
                ),
                const SizedBox(height: 48),
                GradientButton(
                  text: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: () async {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      await ref
                          .read(persistenceServiceProvider)
                          .setOnboardingSeen();

                      // Request permissions before navigating
                      if (mounted) {
                        await PermissionService.requestOnboardingPermissions(
                          context,
                        );
                      }

                      if (mounted) context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 64.h,
            right: 24.w,
            child: TextButton(
              onPressed: () async {
                await ref.read(persistenceServiceProvider).setOnboardingSeen();
                if (mounted) context.go('/login');
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: isActive ? 24.w : 8.w,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.secondary
            : theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(4.w),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              data.icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 80.w,
            ),
          ),
          SizedBox(height: 64.h),
          Text(
            data.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 16.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
