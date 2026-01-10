import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color>? gradient;
  final double? width;
  final double height;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width,
    this.height = 56,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    final defaultGradient = [color, color.withOpacity(0.8)];

    return Container(
      width: width ?? double.infinity,
      height: height.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient ?? defaultGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: (gradient?.first ?? defaultGradient.first).withValues(
              alpha: 0.3,
            ),
            blurRadius: 15.w,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.w),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20.w),
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: GoogleFonts.redHatDisplay(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
