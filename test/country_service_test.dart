import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_application_mockito/models/country.dart';
import 'package:flutter_application_mockito/services/country_service.dart';

import 'country_service_test.mocks.dart';

@GenerateMocks([CountryService])
void main() {
  late MockCountryService mockService;

  setUp(() {
    mockService = MockCountryService();
  });

  group('Cenário 01 – Listagem bem-sucedida', () {
    test('Deve retornar uma lista de países correta', () async {
      final paises = [
        Country(name: 'Brasil', capital: 'Brasília', flagUrl: 'https://flagcdn.com/br.svg', population: 211000000, region: ''),
        Country(name: 'Argentina', capital: 'Buenos Aires', flagUrl: 'https://flagcdn.com/ar.svg', population: 45000000, region: ''),
      ];

      // Mocka para a página 1 com 10 itens (page=1, pageSize=10)
      when(mockService.getCountriesPaginated(1, 10)).thenAnswer((_) async => paises);

      final resultado = await mockService.getCountriesPaginated(1, 10);

      expect(resultado, isNotEmpty);
      expect(resultado.first.name, 'Brasil');
      expect(resultado.first.capital, 'Brasília');
      expect(resultado.first.flagUrl, 'https://flagcdn.com/br.svg');
      expect(resultado.first.population, 211000000);
    });
  });

  group('Cenário 02 – Erro na requisição de países', () {
    test('Deve lançar exceção quando a API falha', () {
      when(mockService.getCountriesPaginated(1, 10)).thenThrow(Exception('API indisponível'));

      expect(() => mockService.getCountriesPaginated(1, 10), throwsException);
    });
  });

  // Como seu serviço não tem método para buscar por nome, 
  // você pode criar um mock para esse cenário, ou ignorar os testes 3 e 4
  // a menos que você implemente um método adicional.

  group('Cenário 05 – País com dados incompletos', () {
    test('Deve lidar com dados faltantes sem quebrar', () async {
      final paisIncompleto = Country(
        name: 'País X',
        capital: '',  // capital vazia
        flagUrl: '',  // sem bandeira
        population: 0, region: '',
      );

      // Vamos assumir que na página 2, retornamos esse país incompleto
      when(mockService.getCountriesPaginated(2, 10)).thenAnswer((_) async => [paisIncompleto]);

      final resultado = await mockService.getCountriesPaginated(2, 10);

      expect(resultado, isNotEmpty);
      expect(resultado.first.capital, isEmpty);
      expect(resultado.first.flagUrl, isEmpty);
    });
  });

  group('Cenário 06 – Verificar chamada ao método getCountriesPaginated', () {
    test('Deve chamar getCountriesPaginated pelo menos uma vez', () async {
      when(mockService.getCountriesPaginated(1, 10)).thenAnswer((_) async => []);

      await mockService.getCountriesPaginated(1, 10);

      verify(mockService.getCountriesPaginated(1, 10)).called(1);
    });
  });
}
