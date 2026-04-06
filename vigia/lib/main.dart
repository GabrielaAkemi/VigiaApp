import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importante!
import 'core/app_colors.dart';
import 'core/theme_manager.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const VigiaApp(),
    ),
  );
}

class VigiaApp extends StatelessWidget {
  const VigiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeManager>();

    return ScreenUtilInit(
      designSize: const Size(390, 844), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Vigia Driver',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,

          // --- CONFIGURAÇÃO DO MODO DIURNO ---
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            primaryColor: AppColors.lightRed,
            textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
            colorScheme: const ColorScheme.light(
              primary: AppColors.lightRed,
              secondary: AppColors.lightOrange,
              surface: Colors.white,
            ),
          ),

          // --- CONFIGURAÇÃO DO MODO NOTURNO ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBg,
            primaryColor: AppColors.darkNeonRed,
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
            colorScheme: const ColorScheme.dark(
              primary: AppColors.darkNeonRed,
              secondary: AppColors.darkAccent,
              surface: AppColors.darkDeepRed,
            ),
          ),
          
          home: child,
        );
      },
      child: const LoginScreen(),
    );
  }
}