import 'package:heig_front/services/api/response_types/notes.dart';

double getMean(List<Note> grades) {
  double sum = 0;
  double divider = 0;
  for (int i = 0; i < grades.length; i++) {
    sum += grades[i].note;
    divider += grades[i].coef;
  }
  return sum / divider;
}

double getMinToGetMean(List<Note> grades, double nextGradeCoeff) {
  const double MEAN = 4;
  final double mean = getMean(grades);

  if (mean > MEAN) {
    return 0;
  }

  final double minGrade =
      (MEAN * (nextGradeCoeff + 1)) / (nextGradeCoeff + mean);

  return minGrade;
}
