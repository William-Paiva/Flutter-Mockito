class Country {
  final String name;
  final String capital;
  final String flagUrl;
  final int population;
  final String region;

  Country({
    required this.name,
    required this.capital,
    required this.flagUrl,
    required this.population,
    required this.region,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] != null && json['name']['common'] != null
          ? json['name']['common'] as String
          : '',
      capital: json['capital'] != null && (json['capital'] as List).isNotEmpty
          ? json['capital'][0] as String
          : '',
      flagUrl: json['flags'] != null && json['flags']['png'] != null
          ? json['flags']['png'] as String
          : '',
      population: json['population'] != null
          ? (json['population'] as int)
          : 0,
      region: json['region'] != null
          ? json['region'] as String
          : '',
    );
  }
}
