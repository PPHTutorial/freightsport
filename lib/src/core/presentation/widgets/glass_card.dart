import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final Color? color;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = 15.0,
    this.opacity = 0.1,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16.w),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: (color ?? Theme.of(context).colorScheme.surface).withOpacity(
              opacity,
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(16.w),
            border:
                border ??
                Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.1),
                  width: 1.5.w,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
