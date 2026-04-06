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

    // O ScreenUtilInit deve envolver o MaterialApp para a responsividade funcionar
    return ScreenUtilInit(
      // DesignSize é o tamanho base do seu protótipo (largura, altura)
      designSize: const Size(390, 844), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Vigia Driver',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,

          // --- CONFIGURAÇÃO DO MODO DIURNO (Light) ---
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

          // --- CONFIGURAÇÃO DO MODO NOTURNO (Dark Neon) ---
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
          
          // O 'child' aqui refere-se ao LoginScreen definido abaixo
          home: child,
        );
      },
      // CORREÇÃO: Adicionado 'const' aqui para melhorar a performance
      child: const LoginScreen(),
    );
  }
}