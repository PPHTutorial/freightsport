import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class ModernBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ModernNavItem> destinations;

  const ModernBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.w,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / destinations.length;
              return Stack(
                children: [
                  // High-quality sliding indicator (Flat style)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    left: selectedIndex * itemWidth + (itemWidth * 0.1),
                    bottom: 0,
                    child: Container(
                      width: itemWidth * 0.8,
                      height: 3.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3.w),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(destinations.length, (index) {
                      final item = destinations[index];
                      final isSelected = selectedIndex == index;
                      return Expanded(
                        child: InkWell(
                          onTap: () => onDestinationSelected(index),
                          splashColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                          highlightColor: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.accentOrange
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  item.icon,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.5),
                                  size: 20.w,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.5),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ModernNavItem {
  final IconData icon;
  final String label;

  const ModernNavItem({required this.icon, required this.label});
}
