import 'package:flutter_test/flutter_test.dart';
import 'package:taskmate/models/quote.dart';

void main() {
  group('Quote Model Test', () {
    test('Berhasil mengubah JSON menjadi Quote', () {
      final json = {
        'id': 1,
        'quote': 'Belajar adalah proses menuju keberhasilan.',
        'author': 'Albert Einstein',
      };

      final result = Quote.fromJson(json);

      expect(result.id, 1);
      expect(result.quote, 'Belajar adalah proses menuju keberhasilan.');
      expect(result.author, 'Albert Einstein');
    });

    test('Data Quote sesuai dengan nilai yang diberikan', () {
      final quote = Quote(
        id: 2,
        quote: 'Jangan berhenti belajar.',
        author: 'Anonymous',
      );

      expect(quote.id, 2);
      expect(quote.quote, 'Jangan berhenti belajar.');
      expect(quote.author, 'Anonymous');
    });
  });
}
