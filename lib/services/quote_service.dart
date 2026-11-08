import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quote.dart';

class QuoteService {
  static const String baseUrl = 'https://dummyjson.com/quotes';

  Future<List<Quote>> fetchQuotes() async {
    final response = await http
        .get(Uri.parse('$baseUrl?limit=5'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final List<dynamic> quoteList = data['quotes'] as List<dynamic>;

      return quoteList.map((item) {
        return Quote.fromJson(item as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception(
        'Gagal mengambil data API. '
        'Status code: ${response.statusCode}',
      );
    }
  }
}
