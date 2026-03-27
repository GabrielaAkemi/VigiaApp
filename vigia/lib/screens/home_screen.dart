import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_manager.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';
import '../widgets/neon_typewriter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primary = AppColors.getPrimary(context);

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 120.h,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "VIGIA",
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 38.sp,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(color: primary.withOpacity(0.7), blurRadius: 15.r),
                  ],
                ),
              ),
              NeonTypewriter(
                texts: const [
                  "Bem vindo(a), Gabriela",
                  "Pronta para a rota?",
                  "Segurança em primeiro lugar",
                ],
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton(
                icon: Icon(Icons.notifications_none, color: primary, size: 28.r),
                onPressed: () {
                  print("Notificações clicadas");
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Visão Geral da Rota Diária",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              
              NeonCard(
                child: Column(
                  children: [
                    _buildRouteStep("Pickup 12:30", "Caneryalone, Anna S.", context, true),
                    _buildRouteStep("Pickup 13:00", "Emergency service, IW", context, false),
                  ],
                ),
              ),
              
              SizedBox(height: 30.h),
              
              // BOTÃO INICIAR: Agora com print para debug no console
              _buildActionButton(
                "INICIAR ROTA", 
                context, 
                onTap: () {
                  print("Botão Iniciar Rota pressionado!");
                  context.read<ThemeManager>().setIndex(1);
                },
              ),
              
              SizedBox(height: 15.h),
              _buildActionButton("PAUSAR", context, onTap: () => print("Pausar")),
              SizedBox(height: 15.h),
              _buildActionButton("ENCERRAR ROTA", context, onTap: () => print("Encerrar")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteStep(String time, String loc, BuildContext context, bool isFirst) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Column(
        children: [
          Icon(Icons.circle, size: 12.r, color: AppColors.getPrimary(context)),
          if (!isFirst) Container(width: 2.w, height: 20.h, color: Colors.grey),
        ],
      ),
      title: Text(time, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
      subtitle: Text(
        loc,
        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14.sp),
      ),
    );
  }

  Widget _buildActionButton(String label, BuildContext context, {required VoidCallback onTap}) {
    Color primary = AppColors.getPrimary(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque, // GARANTE QUE O CLIQUE FUNCIONE EM TODA A ÁREA
        child: Container(
          width: double.infinity,
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: primary, width: 2.w),
            boxShadow: [
              BoxShadow(color: primary.withOpacity(0.2), blurRadius: 10.r),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: primary, 
                fontWeight: FontWeight.bold, 
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}