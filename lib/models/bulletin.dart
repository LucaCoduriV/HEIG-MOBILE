import 'package:hive_flutter/adapters.dart';

import 'branche.dart';

part 'bulletin.g.dart';

@HiveType(typeId: 1)
class Bulletin {
  @HiveField(0)
  late List<Branche> branches;
  @HiveField(1)
  late int year;

  Bulletin(List<Branche>? branches, {int year = 2020}) {
    this.branches = branches ?? [];
    this.year = year;
  }

  @override
  String toString() {
    return "nombre de branches: ${branches.length}, ${branches.toString()}";
  }
}
