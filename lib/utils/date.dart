const List<String> NOM_JOURS_SEMAINE = [
  'inconnu',
  'Lundi',
  'Mardi,',
  'Mercredi',
  'Jeudi',
  'Vendredi',
  'Samedi',
  'Dimanche'
];

const List<String> NOM_MOIS = [
  'inconnu',
  'Janvier',
  'Février',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Aout',
  'Septembre',
  'Octobre',
  'Novembre',
  'Decembre',
];

extension DateCalc on DateTime {
  DateTime firstDayOfWeek() {
    return findFirstDateOfTheWeek(this);
  }

  DateTime lastDayOfWeek() {
    return findLastDateOfTheWeek(this);
  }
}

/// Find the first date of the week which contains the provided date.
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

/// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}
