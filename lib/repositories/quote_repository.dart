import '../models/quote.dart';
import '../services/quote_service.dart';

class QuoteRepository {
  final QuoteService quoteService;

  QuoteRepository({required this.quoteService});

  Future<List<Quote>> getQuotes() async {
    try {
      return await quoteService.fetchQuotes();
    } catch (error) {
      throw Exception('Gagal memuat kutipan: $error');
    }
  }
}
