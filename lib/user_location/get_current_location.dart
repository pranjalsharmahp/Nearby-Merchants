import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as devtools;

import 'package:nearby_merchants/merchants/merchants_lister.dart';

class GetCurrentLocation extends StatefulWidget {
  const GetCurrentLocation({super.key});

  @override
  State<GetCurrentLocation> createState() => _GetCurrentLocationState();
}

class _GetCurrentLocationState extends State<GetCurrentLocation> {
  @override
  void initState() {
    super.initState();
    _logLocation();
    getAllMerchants();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<void> _logLocation() async {
  final pos = await getCurrentLocation();

  devtools.log(pos.toString());
}

Future<Position> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    print('Location services are denied');
    permission = await Geolocator.requestPermission();
  }
  Position currentPosition = await Geolocator.getCurrentPosition();
  return currentPosition;
}
