import 'notes.dart';

class Bulletin {
  late List<Note> bulletin;

  Bulletin(bulletin) {
    this.bulletin = bulletin ?? [];
  }

  @override
  String toString() {
    return "nombre de notes: ${bulletin.length}";
  }
}
