import 'package:heig_front/models/notes.dart';

/// Return the mean of [grades]
double calculateMean(List<Note> grades) {
  double sum = 0;
  double divider = 0;
  for (int i = 0; i < grades.length; i++) {
    sum += grades[i].note * grades[i].coef;
    divider += grades[i].coef;
  }
  return sum / divider;
}

/// Returns the next grade to do to get at least [target] grade.
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
