import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby_merchants/views/home_view.dart';

void main() => runApp(const MerchantFinderApp());

/// Central place for brand colours
class BrandColors {
  static const yellow = Color(0xFFF9BE04);
  static const bg = Color(0xFF0F0F0F);
  static const card = Color(0xFF1E1E1E);
}

class MerchantFinderApp extends StatelessWidget {
  const MerchantFinderApp({super.key});

  ThemeData get _theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: BrandColors.bg,
    textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: BrandColors.yellow,
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merchant Finder',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: const MerchantFinderPage(),
    );
  }
}
