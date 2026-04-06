import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class NeonContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const NeonContainer({
    super.key, 
    required this.child, 
    this.borderRadius = 15,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = AppColors.getPrimary(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.8), 
          width: 1.5
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: isDark ? 10 : 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}