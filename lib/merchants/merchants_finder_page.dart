import 'package:flutter/material.dart';
import 'package:nearby_merchants/merchants/merchants_lister.dart';

class MerchantFinderPage extends StatefulWidget {
  const MerchantFinderPage({super.key});

  static const _yellow = Color(0xFFF9BE04);
  static const _card = Color(0xFF1E1E1E);

  @override
  State<MerchantFinderPage> createState() => _MerchantFinderPageState();
}

class _MerchantFinderPageState extends State<MerchantFinderPage> {
  late Future<List<Merchants>> _merchantsFuture;

  @override
  void initState() {
    super.initState();
    _merchantsFuture = getAllMerchants(); // kick off once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style: TextStyle(color: MerchantFinderPage._yellow),
        ),
        TextSpan(text: 'Near You'),
      ],
    ),
  );

  Widget _buildSearchButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: MerchantFinderPage._yellow,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 0,
    ),
    onPressed: () {
      // refresh list
      setState(() async => _merchantsFuture = getAllMerchants());
    },
    child: const Text(
      'Search',
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    ),
  );

  Widget _buildMerchantList() => FutureBuilder<List<Merchants>>(
    future: _merchantsFuture,
    builder: (context, snap) {
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snap.hasError) {
        return Center(child: Text('Error: ${snap.error}'));
      }
      final merchants = snap.data ?? [];
      if (merchants.isEmpty) {
        return const Center(child: Text('No merchants found.'));
      }
      return ListView.separated(
        itemCount: merchants.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _MerchantCard(merchants[i]),
      );
    },
  );
}

class _MerchantCard extends StatelessWidget {
  const _MerchantCard(this.merchant);

  final Merchants merchant;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MerchantFinderPage._card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListTile(
        leading: const Icon(
          Icons.store,
          color: MerchantFinderPage._yellow,
          size: 28,
        ),
        title: Text(merchant.name),
        subtitle: Text(merchant.shopType),
        dense: true,
      ),
    );
  }
}
