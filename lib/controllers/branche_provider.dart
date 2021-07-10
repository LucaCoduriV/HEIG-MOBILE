import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BulletinProvider {
  late Bulletin _bulletin;
  var box = Hive.box('heig');

  BulletinProvider() {
    Bulletin hiveBulletin = box.get('bulletin', defaultValue: Bulletin([]));
    _bulletin = hiveBulletin;
  }

  Stream<Bulletin> getBulletin(String username, String password) async* {
    yield _bulletin;
    _bulletin = await GetIt.I<ApiController>().fetchNotes(username, password);
    if (_bulletin != null) box.put('bulletin', _bulletin);
    yield _bulletin;
  }
}
