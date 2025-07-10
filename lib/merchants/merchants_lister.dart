import 'package:flutter_overpass/flutter_overpass.dart';
import 'package:geolocator/geolocator.dart';

class Merchants {
  final String name;
  final String shopType;
  final double lat;
  final double long;

  Merchants({
    required this.lat,
    required this.long,
    required this.name,
    required this.shopType,
  });
}

/// Fetches nearby merchants using an efficient, server-side filtered query.
Future<List<Merchants>> getAllMerchants({required Position atLocation}) async {
  final overpass = FlutterOverpass();

  final result = await overpass.getNearbyNodes(
    latitude: atLocation.latitude,
    longitude: atLocation.longitude,
    radius: 10000,
  );

  final List<Merchants> allMerchants = [];
  if (result.elements == null) return allMerchants;

  for (final node in result.elements!) {
    final name = node.tags?.name ?? 'Unnamed';

    final amenity = node.tags?.amenity;
    final type = amenity ?? 'Misc';

    String prettify(String s) =>
        s.replaceAll('_', ' ').replaceFirst(s[0], s[0].toUpperCase());

    allMerchants.add(
      Merchants(
        name: name,
        shopType: prettify(type),
        lat: node.lat ?? 0,
        long: node.lon ?? 0,
      ),
    );
  }
  return allMerchants;
}
