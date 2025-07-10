import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_merchants/main.dart';
import 'package:nearby_merchants/merchants/merchants_lister.dart';

class MapView extends StatelessWidget {
  final Position userPosition;
  final List<Merchants> merchants;

  const MapView({
    super.key,
    required this.userPosition,
    required this.merchants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchants Map'),
        backgroundColor: BrandColors.bg,
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(userPosition.latitude, userPosition.longitude),
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.nearby_merchants.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(userPosition.latitude, userPosition.longitude),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ),
              ...merchants.map((merchant) {
                return Marker(
                  point: LatLng(merchant.lat, merchant.long),
                  width: 40,
                  height: 40,
                  child: Tooltip(
                    message: merchant.name,
                    child: const Icon(
                      Icons.location_pin,
                      color: BrandColors.yellow,
                      size: 30,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
