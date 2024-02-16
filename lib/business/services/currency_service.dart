import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pp_26/business/models/currency_uint.dart';

class CurrencyService {
  Future<List<CurrencyUint>> getCurrencyUints() async {
    List<CurrencyUint> currencies =[];
    try {
      final response = await http.get(
        Uri.parse('https://coinranking1.p.rapidapi.com/reference-currencies?limit=30'),
        headers: {
          'X-RapidAPI-Key':
          '894c12740cmshc0268519b72cc5fp1dea02jsn7b7a5b95c67e',
          'X-RapidAPI-Host': 'coinranking1.p.rapidapi.com'
        },
      );
      if (response.statusCode == 200) {
        final currenciesJson = jsonDecode(response.body)['data']['currencies'] as List<dynamic>;
        for (var currencyJson in currenciesJson) {
          if (CurrencyUint.fromJson(currencyJson).symbol == 'RUB') {

          } else {
            currencies.add(CurrencyUint.fromJson(currencyJson));
          }
        }
        return currencies;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}