import 'package:flutter_test/flutter_test.dart';
import 'package:heig_front/services/api/response_types/notes.dart';
import 'package:heig_front/utils/grades_functions.dart';

Future<void> main() async {
  group('getMean', () {
    const note1 = Note('nom', 5.8, 5, 0.1);
    const note2 = Note('nom', 3.8, 5, 1);

    const list = [note1, note2];

    test('should return 3.9818181818181815', () async {
      expect(calculateMean(list), 3.9818181818181815);
    });
  });

  group('getMinGradeToGetMean', () {
    test('should return 4', () async {
      expect(getMinToGetMean(2, 1), 6);
    });
  });
}
