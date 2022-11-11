import 'package:flutter/material.dart';

import '../../model/country.dart';
import 'details_big_screen.dart';
import 'details_mobile_screen.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({required this.country, super.key});
  final Country country;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => constraint.maxWidth <= 620
          ? DetailsMobileScreen(country: country)
          : DetailsBigScreen(country: country),
    );
  }
}
