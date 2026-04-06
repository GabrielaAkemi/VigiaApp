import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importação essencial
import '../core/app_colors.dart';
import '../widgets/neon_button.dart';
import '../widgets/background_wrapper.dart';
import 'main_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = AppColors.getPrimary(context);

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: SingleChildScrollView( 
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 120.h), 
                Text(
                  "Vigia",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 70.sp, 
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        // CORREÇÃO: withOpacity -> withValues
                        color: primaryColor.withValues(alpha: 0.8), 
                        blurRadius: isDark ? 20.r : 10.r
                      )
                    ],
                  ),
                ),
                SizedBox(height: 60.h), 
                _buildInput("EMAIL", context),
                SizedBox(height: 20.h),
                _buildInput("PASSWORD", context, isPassword: true),
                SizedBox(height: 50.h),
                NeonButton(
                  text: "LOGIN", 
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation()),
                    );
                  }
                ),
                SizedBox(height: 40.h), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, BuildContext context, {bool isPassword = false}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54, 
            fontSize: 12.sp
          )
        ),
        SizedBox(height: 8.h),
        Container(
          height: 55.h, 
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkDeepRed : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: AppColors.getPrimary(context).withValues(alpha: 0.5)
            ),
          ),
          child: TextField(
            obscureText: isPassword,
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16.sp),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}