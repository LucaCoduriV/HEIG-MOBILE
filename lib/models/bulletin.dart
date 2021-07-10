import 'branche.dart';

class Bulletin {
  late List<Branche> branches;

  Bulletin(List<Branche>? branches) {
    this.branches = branches ?? [];
  }

  @override
  String toString() {
    return "nombre de branches: ${branches.length}, ${branches.toString()}";
  }
}
