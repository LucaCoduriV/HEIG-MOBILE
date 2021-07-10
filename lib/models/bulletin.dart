import 'package:hive_flutter/adapters.dart';

import 'branche.dart';

part 'bulletin.g.dart';

@HiveType(typeId: 1)
class Bulletin {
  @HiveField(0)
  late List<Branche> branches;

  Bulletin(List<Branche>? branches) {
    this.branches = branches ?? [];
  }

  @override
  String toString() {
    return "nombre de branches: ${branches.length}, ${branches.toString()}";
  }
}
