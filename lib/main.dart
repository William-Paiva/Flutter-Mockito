import 'package:flutter/material.dart';
import 'models/country.dart';
import 'services/country_service_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CountryListScreen(),
    );
  }
}

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});
  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> futureCountries;

  @override
  void initState() {
    super.initState();
    futureCountries = CountryServiceImpl().getCountriesPaginated(0, 10); // página 0, 10 itens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Países')),
      body: FutureBuilder<List<Country>>(
        future: futureCountries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum país encontrado'));
          }

          final countries = snapshot.data!;
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                leading: country.flagUrl.isNotEmpty
                    ? Image.network(country.flagUrl, width: 40, errorBuilder: (_, __, ___) => const Icon(Icons.flag))
                    : const Icon(Icons.flag),
                title: Text(country.name),
                subtitle: Text('${country.capital} - Pop: ${country.population}'),
              );
            },
          );
        },
      ),
    );
  }
}
