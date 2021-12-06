import 'package:heig_front/services/api/response_types/notes.dart';

/// Return the mean of the [grades]
double calculateMean(List<Note> grades) {
  double sum = 0;
  double divider = 0;
  for (int i = 0; i < grades.length; i++) {
    sum += grades[i].note * grades[i].coef;
    divider += grades[i].coef;
  }
  return sum / divider;
}

/// Returns the next grade to have at least [target] grade.
double getMinToGetMean(
  double currentGrade,
  double nextGradeCoeff, {
  double target = 4,
}) {
  if (currentGrade > target) {
    return 0;
  }

  final double minGrade =
      (target * (nextGradeCoeff + 1) - currentGrade) / nextGradeCoeff;

  return minGrade;
}
