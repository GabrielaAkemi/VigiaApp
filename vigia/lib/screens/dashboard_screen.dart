import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/app_colors.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = AppColors.getPrimary(context);
    Color textColor = isDark ? Colors.white : Colors.black;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Painel Dashboard",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Icon(Icons.settings_outlined, color: primaryColor, size: 24.r),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSmallStat("Rotas de Hoje", "9", context)),
                  SizedBox(width: 15.w),
                  Expanded(child: _buildSmallStat("Passageiros", "2", context)),
                ],
              ),
              SizedBox(height: 20.h),

              // CARD DO GRÁFICO BEZIER (ONDA)
              Expanded(
                child: NeonCard(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tempo Médio de Cada Rota", 
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                      SizedBox(height: 10.h),
                      Expanded(child: _buildBezierChart(context)),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom']
                            .map((day) => Text(day, style: TextStyle(color: Colors.grey, fontSize: 10.sp)))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              _buildInfoTile("Quilometros Totais", "20.3 km", context),
              SizedBox(height: 12.h),
              _buildInfoTile("Tempo Médio de Resposta", "13s", context),
              
              SizedBox(height: 10.h), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBezierChart(BuildContext context) {
    Color primary = AppColors.getPrimary(context);
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true, 
            curveSmoothness: 0.35,
            color: primary,
            barWidth: 4.w,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.5),
                  primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            spots: const [
              FlSpot(0, 3),
              FlSpot(2, 4),
              FlSpot(4, 2),
              FlSpot(6, 5),
              FlSpot(8, 3),
              FlSpot(10, 4.5),
              FlSpot(12, 3.8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String title, String value, BuildContext context) {
    return NeonCard(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
          SizedBox(height: 5.h),
          Text(value, style: TextStyle(
            color: AppColors.getPrimary(context), 
            fontSize: 26.sp, 
            fontWeight: FontWeight.bold
          )),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return NeonCard(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          Text(value, style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
            fontSize: 16.sp, 
            fontWeight: FontWeight.bold
          )),
        ],
      ),
    );
  }
}