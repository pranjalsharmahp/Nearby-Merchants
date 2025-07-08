import 'package:flutter_overpass/flutter_overpass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_merchants/user_location/get_current_location.dart';

class Merchants {
  final String name;
  final String shopType;

  Merchants({required this.name, required this.shopType});
}

Future<List<Merchants>> getAllMerchants() async {
  final overpass = FlutterOverpass();
  Position currentPos = await getCurrentLocation();
  final currentLatitude = 30.761631;
  final currentLongitude = 76.610118;

  final shops = await overpass.getNearbyNodes(
    latitude: currentLatitude,
    longitude: currentLongitude,
    radius: 10000,
  );

  final List<Merchants> allMerchants = <Merchants>[];
  for (final node in shops.elements ?? <Element>[]) {
    final name = node.tags?.name ?? 'No name';
    final shopType = node.tags?.amenity ?? '(Unknown)';
    if (shopType != '(Unknown)' &&
        shopType != 'hospital' &&
        shopType != 'college') {
      allMerchants.add(Merchants(name: name, shopType: shopType));
    }
  }
  return allMerchants;
}
