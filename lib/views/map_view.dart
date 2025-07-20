import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  LatLng _currentCenter = LatLng(30.033333, 31.233334); // Cairo by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentCenter,
              zoom: 13.0,
              onPositionChanged: (pos, _) {
                if (pos.center != null) {
                  setState(() {
                    _currentCenter = pos.center!;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.fruite_salad_shop',
              ),
            ],
          ),

          // Pin in center
          const Center(
            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),

          // Confirm button
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _currentCenter);
              },
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}
