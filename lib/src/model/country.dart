import 'dart:convert';

class Country {
  const Country({
    required this.name,
    required this.population,
    required this.continent,
    required this.capital,
    required this.officialLanguage,
    /*
    required this.motto,
    required this.ethnicGroup,
    required this.religion,
    required this.government,

    
    required this.gdp,*/

    required this.currency,
    required this.independence,
    required this.area,
    required this.timezone,
    required this.dateFormat,
    //required this.diallingCode,
    required this.flag,
    required this.drivingSide,
    required this.borders,
    required this.unMember,
    required this.rootCode,
    required this.suffixCode,
  });
  final String rootCode;
  final String suffixCode;
  final String name;
  final String flag;
  final num population;
  final String continent;
  final String capital;
  final Map<String, dynamic> currency;
  final Map<String, dynamic> officialLanguage;
  final bool independence;
  final bool unMember;
  final num area;
  final String timezone;
  final String dateFormat;
  //final String diallingCode;
  final String drivingSide;
  final List borders;

/*
 
  
  final num gdp;

  final String ethnicGroup;
  final String motto;
  final String religion;
  final String government;
 */

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name']["official"] ?? '',
      flag: map["flags"]["png"],
      population: map['population'] ?? 0.0,
      continent: map['continents'][0] ?? '',
      capital: map['capital']?[0] ?? '',
      area: map['area'] ?? '',
      drivingSide: map['car']["side"] ?? '',
      timezone: map['timezones'][0] ?? '',
      officialLanguage: map['languages'] ?? {},
      rootCode: map['idd']["root"] ?? '',
      suffixCode: map["idd"]["suffixes"]?[0] ?? '',
      independence: map['independent'] ?? false,
      unMember: map["unMember"],
      dateFormat: map['dateFormat'] ?? 'dd/mm/yyyy',
      borders: map["borders"] ?? [],
      currency: map['currencies'] ?? {},
/*
      motto: map['motto'] ?? '',
      ethnicGroup: map['ethnicGroup'] ?? '',
      religion: map['religion'] ?? '',
      government: map['government'] ?? '',
      gdp: map['gdp'] ?? '',
      */
    );
  }

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Country(rootCode: $rootCode, suffixCode: $suffixCode, name: $name, flag: $flag, population: $population, continent: $continent, capital: $capital, currency: $currency, officialLanguage: $officialLanguage, independence: $independence, unMember: $unMember, area: $area, timezone: $timezone, dateFormat: $dateFormat, drivingSide: $drivingSide, borders: $borders,)';
  }
}
