import 'branche.dart';

class Bulletin {
  late List<Branche> notes;

  Bulletin(bulletin) {
    this.notes = bulletin ?? [];
  }

  @override
  String toString() {
    return "nombre de branches: ${notes.length}, ${notes.toString()}";
  }
}
