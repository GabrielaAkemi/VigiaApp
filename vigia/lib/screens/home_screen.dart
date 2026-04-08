import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/theme_manager.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';
import '../widgets/neon_typewriter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String routeStatus = "start";
  late AnimationController pulseController;

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    pulseController.dispose();
    super.dispose();
  }

  void _showNotifications(BuildContext context, Color primary, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: primary.withValues(alpha: 0.5), width: 1),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                "Novas Corridas Atribuídas",
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    _notificationItem("08/04/2026", "14:30", "Rota Hospital -> Clínica", primary, isDark),
                    _notificationItem("09/04/2026", "07:00", "Rota Residencial Marília", primary, isDark),
                    _notificationItem("10/04/2026", "10:15", "Rota Unimed Centro", primary, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationItem(String date, String time, String route, Color primary, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_ind_outlined, color: primary),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Data: $date | Horário: $time",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                    Shadow(
                      color: primary.withValues(alpha: 0.7),
                      blurRadius: 15.r,
                    ),
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
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_active_outlined,
                  color: primary,
                  size: 28.r,
                ),
                onPressed: () => _showNotifications(context, primary, isDark),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<ThemeManager>().setIndex(1);
                },
                child: NeonCard(
                  child: SizedBox(
                    height: 180.h,
                    child: Stack(
                      children: [
                        Center(
                          child: AnimatedBuilder(
                            animation: pulseController,
                            builder: (context, child) {
                              double scale = 1 + (pulseController.value * 0.2);
                              return Transform.scale(
                                scale: scale,
                                child: Icon(
                                  Icons.location_on,
                                  size: 42.sp,
                                  color: primary,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 15,
                          child: _infoBubble(Icons.my_location, "Você está aqui", primary),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.open_in_full, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Row(
                children: [
                  Expanded(child: _statBubble(context, Icons.people, "8", "Pacientes")),
                  SizedBox(width: 12.w),
                  Expanded(child: _statBubble(context, Icons.access_time, "07:30", "Início da rota")),
                ],
              ),
              SizedBox(height: 25.h),
              NeonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.route, color: primary),
                        const SizedBox(width: 8),
                        Text("Rota de Hoje", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    _routeItem("07:30", "Hospital Central"),
                    _routeItem("08:10", "Clínica Vida"),
                    _routeItem("09:00", "Laboratório São Lucas"),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              _routeButton(primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBubble(IconData icon, String text, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary, width: 1.5),
        boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.5), blurRadius: 12)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primary),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _statBubble(BuildContext context, IconData icon, String value, String label) {
    final primaryColor = AppColors.getPrimary(context);
    return NeonCard(
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 26),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _routeItem(String time, String location) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.red),
          SizedBox(width: 10.w),
          Text(time, style: const TextStyle(color: Colors.grey)),
          SizedBox(width: 10.w),
          Expanded(child: Text(location)),
        ],
      ),
    );
  }

  Widget _routeButton(Color primary) {
    String text = "Iniciar rota";
    Color color = primary;

    if (routeStatus == "start") {
      text = "Iniciar rota";
      color = primary;
    } else if (routeStatus == "pause") {
      text = "Pausar rota";
      color = Colors.orange;
    } else {
      text = "Encerrar rota";
      color = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (routeStatus == "start") {
            routeStatus = "pause";
          } else if (routeStatus == "pause") {
            routeStatus = "end";
          } else {
            routeStatus = "start";
          }
        });
      },
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
        ),
      ),
    );
  }
} // <--- Chave que fecha a classe State (Faltava esta ou a debaixo)