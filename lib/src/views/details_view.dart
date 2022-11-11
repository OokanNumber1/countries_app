import 'package:countries_app/src/widgets/detail_row.dart';
import 'package:flutter/material.dart';

import '../model/country.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({required this.country, super.key});
  final Country country;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => constraint.maxWidth <= 620
          ? DetailsMobile(country: country)
          : DetailsBigScreen(country: country),
    );
  }
}

class DetailsMobile extends StatelessWidget {
  const DetailsMobile({required this.country, super.key});
  final Country country;
  @override
  Widget build(BuildContext context) {
    final details = [
      Detail(label: "Population:   ", text: country.population.toString()),
      Detail(label: "Continent:   ", text: country.continent),
      Detail(label: "Capital:   ", text: country.capital),
      Detail(
          label: "Official language:   ",
          text: country.officialLanguage.values.toList()[0] as String),
      Detail(
          label: "Has independence:   ",
          text: country.independence ? "Yes" : "No"),
      Detail(
          label: "Has UN Membership:   ",
          text: country.unMember ? "Yes" : "No"),
      Detail(label: "Area:   ", text: "${country.area}km^2"),
      Detail(
          label: "Currency:   ",
          text: country.currency.keys.isEmpty
              ? "GLD"
              : country.currency.keys.toList()[0]),
      Detail(label: "Time zone:   ", text: country.timezone),
      Detail(label: "Date format:   ", text: country.dateFormat),
      Detail(
          label: "Dialling code:   ",
          text: country.rootCode + country.suffixCode),
      Detail(label: "Driving side:   ", text: country.drivingSide),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          country.name,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(country.flag, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              details.length,
              (index) => Padding(
                padding: index % 3 == 0
                    ? const EdgeInsets.only(top: 16.0)
                    : EdgeInsets.zero,
                child: DetailRow(detail: details[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailsBigScreen extends StatelessWidget {
  const DetailsBigScreen({required this.country, super.key});
  final Country country;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final details = [
      Detail(label: "Population: ", text: country.population.toString()),
      Detail(label: "Continent: ", text: country.continent),
      Detail(label: "Capital: ", text: country.capital),
      Detail(
          label: "Official language: ",
          text: country.officialLanguage.values.toList()[0] as String),
      Detail(
          label: "Has independence: ",
          text: country.independence ? "Yes" : "No"),
      Detail(
          label: "Has UN Membership: ", text: country.unMember ? "Yes" : "No"),
      Detail(label: "Area: ", text: "${country.area}km^2"),
      Detail(
          label: "Currency: ",
          text: country.currency.keys.isEmpty
              ? "GLD"
              : country.currency.keys.toList()[0]),
      Detail(label: "Time zone: ", text: country.timezone),
      Detail(label: "Date format: ", text: country.dateFormat),
      Detail(
          label: "Dialling code: ",
          text: country.rootCode + country.suffixCode),
      Detail(label: "Driving side: ", text: country.drivingSide),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          country.name,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.36,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(country.flag, fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.48,
              child: ListView(
                children: List.generate(
                  details.length,
                  (index) => Padding(
                    padding: index % 3 == 0 && index != 0
                        ? const EdgeInsets.only(top: 16.0)
                        : EdgeInsets.zero,
                    child: DetailRow(detail: details[index]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
