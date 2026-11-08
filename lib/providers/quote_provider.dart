import 'package:flutter/foundation.dart';

import '../models/quote.dart';
import '../repositories/quote_repository.dart';

class QuoteProvider extends ChangeNotifier {
  final QuoteRepository repository;

  QuoteProvider({required this.repository});

  List<Quote> _quotes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Quote> get quotes => _quotes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchQuotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _quotes = await repository.getQuotes();
    } catch (error) {
      _errorMessage = error.toString();
      _quotes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
