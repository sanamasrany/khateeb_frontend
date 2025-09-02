class Country {
  final String name;
  final String cca2;

  Country({required this.name, required this.cca2});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'],
      cca2: json['cca2'],
    );
  }
}