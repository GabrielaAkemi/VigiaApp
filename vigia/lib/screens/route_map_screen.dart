import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
// CORREÇÃO: Removido o import desnecessário de foundation.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../core/app_colors.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/neon_card.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> with TickerProviderStateMixin {
  final String ipServidor = '127.0.0.1'; 
  final LatLng origem = const LatLng(-22.2208, -49.9486);
  final LatLng destino = const LatLng(-22.2150, -49.9550);

  List<LatLng> pontosRota = [];
  List<dynamic> passosDaRota = [];
  LatLng? posicaoAtual;
  double rotacaoAnimada = 0.0;
  double rotacaoCarro = 0.0;
  int indicePontoAtual = 0;
  int indicePassoAtual = 0;

  String tempoRestante = "Calculando...";
  String passageiroAtual = "ANNA S.";

  late AnimationController _animController;
  Animation<LatLng>? _animacaoPosicao;
  final MapController _mapController = MapController();
  final Distance distancia = const Distance();

  @override
  void initState() {
    super.initState();
    posicaoAtual = origem;
    _animController = AnimationController(vsync: this);

    _animController.addListener(() {
      if (_animacaoPosicao == null) return;
      
      double diferenca = rotacaoCarro - rotacaoAnimada;
      
      while (diferenca <= -180) {
        diferenca += 360;
      }
      while (diferenca > 180) {
        diferenca -= 360;
      }
      
      rotacaoAnimada += diferenca * 0.08;

      setState(() {
        posicaoAtual = _animacaoPosicao!.value;
      });

      _mapController.moveAndRotate(posicaoAtual!, 18.0, 360 - rotacaoAnimada);
    });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _irParaProximoPonto();
    });

    buscarRotaOSRM();
  }

  Future<void> buscarRotaOSRM() async {
    final String url = 'http://$ipServidor:5000/route/v1/driving/${origem.longitude},${origem.latitude};${destino.longitude},${destino.latitude}?overview=full&geometries=geojson&steps=true';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final rota = data['routes'][0];
        final List coords = rota['geometry']['coordinates'];
        setState(() {
          pontosRota = coords.map((c) => LatLng(c[1], c[0])).toList();
          passosDaRota = rota['legs'][0]['steps'];
          tempoRestante = "${(rota['duration'] / 60).toStringAsFixed(0)} MIN";
        });
        _irParaProximoPonto();
      }
    } catch (e) { 
      debugPrint("Erro OSRM: $e"); 
    }
  }

  void _irParaProximoPonto() {
    if (indicePontoAtual < pontosRota.length - 1) {
      LatLng inicio = pontosRota[indicePontoAtual];
      LatLng fim = pontosRota[indicePontoAtual + 1];
      rotacaoCarro = _calcularAngulo(inicio, fim);
      _animController.duration = Duration(milliseconds: (distancia.distance(inicio, fim) * 40).toInt().clamp(300, 5000));
      _animacaoPosicao = LatLngTween(begin: inicio, end: fim).animate(CurvedAnimation(parent: _animController, curve: Curves.linear));
      indicePontoAtual++;
      _animController.forward(from: 0.0);
    }
  }

  double _calcularAngulo(LatLng inicio, LatLng fim) {
    final double dLon = fim.longitudeInRad - inicio.longitudeInRad;
    final double y = math.sin(dLon) * math.cos(fim.latitudeInRad);
    final double x = math.cos(inicio.latitudeInRad) * math.sin(fim.latitudeInRad) - math.sin(inicio.latitudeInRad) * math.cos(fim.latitudeInRad) * math.cos(dLon);
    return ((math.atan2(y, x) * 180 / math.pi) + 360) % 360;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: origem,
                initialZoom: 18.0,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
              ),
              children: [
                TileLayer(
                  urlTemplate: isDark 
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                    : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                if (pontosRota.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: pontosRota,
                        strokeWidth: 5,
                        color: AppColors.getPrimary(context).withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: posicaoAtual ?? origem,
                      width: 40,
                      height: 40,
                      child: Icon(Icons.navigation, color: AppColors.getPrimary(context), size: 35),
                    ),
                  ],
                ),
              ],
            ),

            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: NeonCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMapStat("PRÓXIMA PARADA", tempoRestante),
                    _buildMapStat("PASSAGEIRO", passageiroAtual),
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

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required super.begin, required super.end});
  @override
  LatLng lerp(double t) => LatLng(
    begin!.latitude + (end!.latitude - begin!.latitude) * t, 
    begin!.longitude + (end!.longitude - begin!.longitude) * t
  );
}