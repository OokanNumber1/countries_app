
import 'package:flutter/material.dart';

import '../model/country.dart';
import '../views/details/details_view.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    Key? key,
    required this.country,
  }) : super(key: key);

  final Country country;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsView(country: country),
          ),
        );
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 40,
          width: 40,
          child: Image.network(
            country.flag,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        country.name,
        style: theme.labelMedium,
      ),
      subtitle: Text(
        country.capital,
        style: theme.titleSmall,
      ),
    );
  }
}
