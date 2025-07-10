import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_merchants/location_service/location_service.dart';
import 'package:nearby_merchants/main.dart';
import 'package:nearby_merchants/merchants/merchants_lister.dart';

import 'package:nearby_merchants/views/map_view.dart';
import 'package:nearby_merchants/widgets/merchant_card.dart';

class MerchantFinderPage extends StatefulWidget {
  const MerchantFinderPage({super.key});

  @override
  State<MerchantFinderPage> createState() => _MerchantFinderPageState();
}

class _MerchantFinderPageState extends State<MerchantFinderPage> {
  Future<List<Merchants>>? _merchantsFuture;
  List<Merchants> _merchants = [];
  Position? _pos;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Try to get location silently on startup.
    // The user can press search to retry if it fails.
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Don't show loading, just get the position if possible.
      if (await Geolocator.isLocationServiceEnabled()) {
        _pos = await getCurrentLocation();
      }
    } catch (_) {
      // Fail silently, user can press search to see the error.
    }
  }

  Future<void> _searchMerchants() async {
    setState(() {
      _isLoading = true;
      _merchantsFuture = null; // Clear previous results
    });

    try {
      // Step 1: Ensure we have a location.
      _pos ??= await getCurrentLocation();

      // Step 2: Fetch merchants with the location.
      final fetchedMerchants = await getAllMerchants(atLocation: _pos!);

      // Step 3: Update state with results.
      setState(() {
        _merchants = fetchedMerchants;
        _merchantsFuture = Future.value(fetchedMerchants);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      // Step 4: Always turn off loading indicator.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColors.yellow,
        onPressed:
            (_merchants.isNotEmpty)
                ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MapView(
                            userPosition: _pos!,
                            merchants: _merchants,
                          ),
                    ),
                  );
                }
                : null,
        child: const Icon(Icons.map, color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              _buildTitle(context),
              const SizedBox(height: 40),
              _buildSearchButton(),
              const SizedBox(height: 40),
              Expanded(child: _buildMerchantList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext ctx) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: Theme.of(
        ctx,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
      children: const [
        TextSpan(text: 'Find '),
        TextSpan(
          text: 'Merchants\n',
          style: TextStyle(color: BrandColors.yellow),
        ),
        TextSpan(text: 'Near You'),
      ],
    ),
  );

  Widget _buildSearchButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: BrandColors.yellow,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    onPressed: _isLoading ? null : _searchMerchants,
    child:
        _isLoading
            ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.black),
            )
            : const Text(
              'Search',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
  );

  Widget _buildMerchantList() {
    if (_merchantsFuture == null && !_isLoading) {
      return const Center(
        child: Text(
          'Press "Search" to find merchants near you.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return FutureBuilder<List<Merchants>>(
      future: _merchantsFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting || _isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('An error occurred: ${snap.error}'));
        }
        final merchants = snap.data ?? [];
        if (merchants.isEmpty) {
          return const Center(child: Text('No merchants found.'));
        }
        return ListView.separated(
          itemCount: merchants.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => MerchantCard(merchants[i]),
        );
      },
    );
  }
}
