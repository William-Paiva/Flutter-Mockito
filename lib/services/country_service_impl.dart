import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import 'country_service.dart';

class CountryServiceImpl implements CountryService {
  @override
  Future<List<Country>> getCountriesPaginated(int page, int pageSize) async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all?fields=name,flags,capital,region,population'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final countries = data.map((e) => Country.fromJson(e)).toList();

      final start = page * pageSize;
      final end = (start + pageSize).clamp(0, countries.length);
      if (start >= countries.length) return [];

      return countries.sublist(start, end);
    } else {
      throw Exception('Erro ao carregar países: status ${response.statusCode}');
    }
  }
}
