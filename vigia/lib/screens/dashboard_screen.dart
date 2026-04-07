import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/app_colors.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              /// 🚑 STATS COLORIDOS
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  _statCard("Rotas Hoje", "9", Icons.route, Colors.blue),

                  _statCard("Passageiros", "18", Icons.people, Colors.cyan),

                  _statCard("Atrasos", "1", Icons.warning, Colors.orange),

                  _statCard("Avaliação", "4.8", Icons.star, Colors.purple),
                ],
              ),

              SizedBox(height: 25.h),

              /// 📈 ROTAS DA SEMANA
              NeonCard(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rotas da Semana",
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),

                    SizedBox(height: 15.h),

                    SizedBox(height: 180.h, child: _lineChart()),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// 🟠 STATUS DAS ROTAS
              NeonCard(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Status das Rotas",
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ),

                    SizedBox(height: 15.h),

                    SizedBox(height: 180.h, child: _pieChart()),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// ⭐ AVALIAÇÕES
              NeonCard(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avaliações dos Passageiros",
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),

                    SizedBox(height: 15.h),

                    SizedBox(height: 180.h, child: _barChart()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📦 CARD COLORIDO
  Widget _statCard(String title, String value, IconData icon, Color color) {
    return NeonCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),

          SizedBox(height: 6),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  /// 📈 LINE CHART
  Widget _lineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.red,
            barWidth: 4,
            dotData: FlDotData(show: false),

            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.red.withOpacity(0.5), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 3),
              FlSpot(2, 4),
              FlSpot(3, 3),
              FlSpot(4, 5),
              FlSpot(5, 4),
              FlSpot(6, 3),
            ],
          ),
        ],
      ),
    );
  }

  /// 🥧 PIE CHART
  Widget _pieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 70,
            color: Colors.green,
            title: "No horário",
            radius: 50,
          ),

          PieChartSectionData(
            value: 20,
            color: Colors.orange,
            title: "Atraso",
            radius: 50,
          ),

          PieChartSectionData(
            value: 10,
            color: Colors.red,
            title: "Cancelado",
            radius: 50,
          ),
        ],
      ),
    );
  }

  /// 📊 BAR CHART
  Widget _barChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),

        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 2, color: Colors.red)],
          ),

          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 4, color: Colors.orange)],
          ),

          BarChartGroupData(
            x: 3,
            barRods: [BarChartRodData(toY: 6, color: Colors.yellow)],
          ),

          BarChartGroupData(
            x: 4,
            barRods: [BarChartRodData(toY: 12, color: Colors.green)],
          ),

          BarChartGroupData(
            x: 5,
            barRods: [BarChartRodData(toY: 20, color: Colors.blue)],
          ),
        ],
      ),
    );
  }
}
