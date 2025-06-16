import 'package:flutter/material.dart';
import 'models/country.dart';
import 'services/country_service.dart'; 
import 'services/country_service_impl.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountryListScreen(
      
        service: CountryServiceImpl(),
      ),
    );
  }
}

class CountryListScreen extends StatefulWidget {
  
  final CountryService service;

  const CountryListScreen({super.key, required this.service});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> futureCountries;

  @override
  void initState() {
    super.initState();
    
    futureCountries = widget.service.getCountriesPaginated(0, 10);
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
                
                key: ValueKey(country.name),
                leading: country.flagUrl.isNotEmpty
                    ? Image.network(country.flagUrl, width: 40, errorBuilder: (_, __, ___) => const Icon(Icons.flag))
                    : const Icon(Icons.flag, key: ValueKey('icon_flag_${country.name}')), 
                title: Text(country.name),
                subtitle: Text('${country.capital} - Pop: ${country.population}'),
                onTap: () {
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CountryDetailScreen(country: country),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CountryDetailScreen extends StatelessWidget {
  final Country country;
  const CountryDetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(country.name)),
      body: Center(
        child: Text('Detalhes de ${country.name}'),
      ),
    );
  }
}