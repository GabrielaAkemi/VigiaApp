import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importação essencial
import '../core/app_colors.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const NeonCard({
    super.key, 
    required this.child, 
    this.borderRadius = 20, 
    this.padding, 
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primary = AppColors.getPrimary(context);

    return Container(
      // Escala o padding proporcionalmente à tela
      padding: padding ?? EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(borderRadius.r), 
        border: Border.all(
          color: primary.withValues(alpha: 0.8), 
          width: 1.5.w, 
        ),
        boxShadow: [
          BoxShadow(
            // ATUALIZADO: Substituído withOpacity por withValues
            color: primary.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: isDark ? 15.r : 8.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: child,
    );
  }
}