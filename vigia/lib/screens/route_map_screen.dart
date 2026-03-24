import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class RouteMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Route Map", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          actions: [IconButton(icon: const Icon(Icons.location_on), onPressed: () {})],
        ),
        body: Stack(
          children: [
            // Simulação do Mapa (Aqui você usaria google_maps_flutter futuramente)
            Container(
              color: isDark ? Colors.black26 : Colors.black12,
              child: Center(
                child: Icon(Icons.map, size: 100, color: AppColors.getPrimary(context).withOpacity(0.2)),
              ),
            ),
            // Card Flutuante de Informação da Rota
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: NeonCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMapStat("NEXT STOP", "4 MIN"),
                    _buildMapStat("PASSENGER", "ANNA S."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}