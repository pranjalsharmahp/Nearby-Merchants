import 'package:flutter/material.dart';
import 'package:nearby_merchants/main.dart';
import 'package:nearby_merchants/merchants/merchants_lister.dart';

class MerchantCard extends StatelessWidget {
  final Merchants merchant;
  const MerchantCard(this.merchant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BrandColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: const Icon(Icons.store, color: BrandColors.yellow, size: 28),
        title: Text(merchant.name),
        subtitle: Text(merchant.shopType),
        dense: true,
      ),
    );
  }
}
