import 'package:flutter/material.dart';
import 'package:flutter_application_mockito/main.dart';
import 'package:flutter_application_mockito/models/country.dart';
import 'package:flutter_application_mockito/services/country_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'country_list_screen_test.mocks.dart';

@GenerateMocks([CountryService])
void main() {

  late MockCountryService mockCountryService;

  final mockCountries = [
    Country(
      name: 'Brazil',
      capital: 'Brasília',
      flagUrl: 'https://flagcdn.com/br.svg', 
      population: 214000000,
      region: 'Americas',
    ),
  ];

  setUp(() {
    mockCountryService = MockCountryService();
  });
 
  Future<void> pumpCountryListScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CountryListScreen(service: mockCountryService),
      ),
    );
  }

  group('Testes da Tela de Listagem de Países', () {
    testWidgets('Cenário 01: Verificar se o nome do país é carregado no componente', (WidgetTester tester) async {
      
      when(mockCountryService.getCountriesPaginated(any, any))
          .thenAnswer((_) async => mockCountries);

      
      await pumpCountryListScreen(tester);

      
      await tester.pumpAndSettle();

      
      expect(find.text('Brazil'), findsOneWidget);
      expect(find.text('Brasília - Pop: 214000000'), findsOneWidget);
    });

    testWidgets('Cenário 03: Verificar se um componente de imagem é carregado com a bandeira', (WidgetTester tester) async {
      
      when(mockCountryService.getCountriesPaginated(any, any))
          .thenAnswer((_) async => mockCountries);

      
      await pumpCountryListScreen(tester);
      await tester.pumpAndSettle();

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<NetworkImage>());
      expect((imageWidget.image as NetworkImage).url, 'https://flagcdn.com/br.svg');
    });

    testWidgets('Cenário 02: Verificar se ao clicar em um país os dados são abertos', (WidgetTester tester) async {
      
      when(mockCountryService.getCountriesPaginated(any, any))
        .thenAnswer((_) async => mockCountries);
      
      
      await pumpCountryListScreen(tester);
      await tester.pumpAndSettle();

      
      await tester.tap(find.byKey(const ValueKey('Brazil')));
      
      await tester.pumpAndSettle();

      
      expect(find.byType(CountryDetailScreen), findsOneWidget);
      expect(find.text('Detalhes de Brazil'), findsOneWidget);
    });

     testWidgets('Deve mostrar um indicador de progresso enquanto carrega', (WidgetTester tester) async {
      
      when(mockCountryService.getCountriesPaginated(any, any))
          .thenAnswer((_) async {
            
            await Future.delayed(const Duration(milliseconds: 100));
            return mockCountries;
          });
      
      
      await pumpCountryListScreen(tester);
      
      await tester.pump(); 

      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      
      await tester.pumpAndSettle();
    });

    testWidgets('Deve mostrar mensagem de erro se a API falhar', (WidgetTester tester) async {
      
      when(mockCountryService.getCountriesPaginated(any, any))
          .thenThrow(Exception('Falha na API'));

      
      await pumpCountryListScreen(tester);
      await tester.pumpAndSettle();

      
      expect(find.text('Erro: Exception: Falha na API'), findsOneWidget);
    });
  });
}