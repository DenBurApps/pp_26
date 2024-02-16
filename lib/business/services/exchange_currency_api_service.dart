import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeCurrencyApiService {
  Future<double>? getExchangeRate({
    required String from,
    required String to,
    required String amount,
  }) async {
    try {
      const String host = 'api.frankfurter.app';
      final Uri uri = Uri.https(host, '/latest', {'amount': amount, 'from': from, 'to': to});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double exchangeRate = double.parse(data['rates'][to].toString());
        return exchangeRate;
      } else {
        throw Exception('Failed to fetch data ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}