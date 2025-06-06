
import 'package:flutter_application_mockito/models/country.dart';

abstract class CountryService {
  Future<List<Country>> getCountriesPaginated(int page, int pageSize);
}
