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
              /// LOGO
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

              /// TEXTO ANIMADO
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
                  Icons.notifications_none,
                  color: primary,
                  size: 28.r,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// MAPA
              GestureDetector(
                onTap: () {
                  context.read<ThemeManager>().setIndex(1);
                },
                child: NeonCard(
                  child: SizedBox(
                    height: 180.h,
                    child: Stack(
                      children: [
                        /// MAPA MOCK
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

                        /// BALÃO LOCALIZAÇÃO
                        Positioned(
                          left: 15,
                          top: 15,
                          child: _infoBubble(
                            Icons.my_location,
                            "Você está aqui",
                            primary,
                          ),
                        ),

                        /// BOTÃO EXPANDIR
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.open_in_full,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              /// ESTATÍSTICAS
              Row(
                children: [
                  Expanded(
                    child: _statBubble(context, Icons.people, "8", "Pacientes"),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: _statBubble(
                      context,
                      Icons.access_time,
                      "07:30",
                      "Início da rota",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25.h),

              /// ROTA
              NeonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.route, color: primary),
                        SizedBox(width: 8),
                        Text(
                          "Rota de Hoje",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
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

              /// BOTÃO ROTA
              _routeButton(primary),
            ],
          ),
        ),
      ),
    );
  }

  /// BALÃO "VOCÊ ESTÁ AQUI"
  Widget _infoBubble(IconData icon, String text, Color primary) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary, width: 1.5),
        boxShadow: [BoxShadow(color: primary.withOpacity(0.5), blurRadius: 12)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primary),

          SizedBox(width: 6),

          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// ESTATÍSTICAS
  Widget _statBubble(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final primary = AppColors.getPrimary(context);

    return NeonCard(
      child: Column(
        children: [
          Icon(icon, color: primary, size: 26),

          SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 4),

          Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  /// ITEM DA ROTA
  Widget _routeItem(String time, String location) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.red),
          SizedBox(width: 10.w),
          Text(time, style: TextStyle(color: Colors.grey)),
          SizedBox(width: 10.w),
          Expanded(child: Text(location)),
        ],
      ),
    );
  }

  /// BOTÃO DE ROTA
  Widget _routeButton(Color primary) {
    String text = "Iniciar rota";
    Color color = primary;

    if (routeStatus == "pause") {
      text = "Pausar rota";
      color = Colors.orange;
    }

    if (routeStatus == "end") {
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
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
