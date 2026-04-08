import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color sectionTitleColor = isDark ? Colors.white : Colors.black87;
    Color appBarTextColor = isDark ? Colors.white : Colors.black;

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
              color: appBarTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  _statCard("Rotas Hoje", "9", Icons.route, Colors.blue, sectionTitleColor),
                  _statCard("Passageiros", "18", Icons.people, Colors.cyan, sectionTitleColor),
                  _statCard("Atrasos", "1", Icons.warning, Colors.orange, sectionTitleColor),
                  _statCard("Avaliação", "4.8", Icons.star, Colors.purple, sectionTitleColor),
                ],
              ),
              SizedBox(height: 25.h),
              _buildChartSection("Rotas da Semana", _lineChart(), sectionTitleColor),
              SizedBox(height: 20.h),
              _buildChartSection(
                "Status das Rotas", 
                Column(
                  children: [
                    SizedBox(height: 160.h, child: _pieChart()),
                    SizedBox(height: 15.h),
                    _buildPieLegend(isDark),
                  ],
                ), 
                sectionTitleColor
              ),
              SizedBox(height: 20.h),
              _buildChartSection("Avaliações dos Passageiros", _barChart(), sectionTitleColor),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(String title, Widget chart, Color textColor) {
    return NeonCard(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: textColor, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          chart,
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, Color titleTextColor) {
    return NeonCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            title, 
            style: TextStyle(color: titleTextColor.withValues(alpha: 0.7), fontSize: 11.sp, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _lineChart() {
    return SizedBox(
      height: 180.h,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.red,
              barWidth: 4,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.red.withValues(alpha: 0.3), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              spots: const [
                FlSpot(0, 2), FlSpot(1, 3), FlSpot(2, 4),
                FlSpot(3, 3), FlSpot(4, 5), FlSpot(5, 4), FlSpot(6, 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(value: 70, color: Colors.green, title: '', radius: 20),
          PieChartSectionData(value: 20, color: Colors.orange, title: '', radius: 20),
          PieChartSectionData(value: 10, color: Colors.red, title: '', radius: 20),
        ],
      ),
    );
  }

  Widget _buildPieLegend(bool isDark) {
    Color labelColor = isDark ? Colors.white70 : Colors.black87;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem("No horário", Colors.green, labelColor),
        _legendItem("Atraso", Colors.orange, labelColor),
        _legendItem("Cancelado", Colors.red, labelColor),
      ],
    );
  }

  Widget _legendItem(String text, Color color, Color textColor) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6), // ADICIONADO: const
        Text(text, style: TextStyle(color: textColor, fontSize: 10.sp)),
      ],
    );
  }

  Widget _barChart() {
    return SizedBox(
      height: 180.h,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: [
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2, color: Colors.red, width: 15, borderRadius: BorderRadius.circular(4))]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4, color: Colors.orange, width: 15, borderRadius: BorderRadius.circular(4))]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 6, color: Colors.yellow, width: 15, borderRadius: BorderRadius.circular(4))]),
            BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 12, color: Colors.green, width: 15, borderRadius: BorderRadius.circular(4))]),
            BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 20, color: Colors.blue, width: 15, borderRadius: BorderRadius.circular(4))]),
          ],
        ),
      ),
    );
  }
}