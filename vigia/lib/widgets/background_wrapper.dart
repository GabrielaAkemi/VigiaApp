import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;


    const Color salmonClear = Color(0x1AFA8072);

    return Container(
      color: AppColors.getBackground(context),
      child: Stack(
        children: [
          if (!isDark)
            Center(
              child: Opacity(
                opacity: 0.8, 
                child: Image.asset(
                  'assets/logo_vigia.png',
                  width: MediaQuery.of(context).size.width * 1.0, 
                  

                  color: salmonClear, 
                  
                  colorBlendMode: BlendMode.modulate, 
                ),
              ),
            ),
            
          if (isDark)
            Center(
              child: Opacity(
                opacity: 0.02,
                child: Image.asset(
                  'assets/logo_vigia.png',
                  width: MediaQuery.of(context).size.width * 0.75,
                ),
              ),
            ),

          Positioned.fill(child: child),
        ],
      ),
    );
  }
}