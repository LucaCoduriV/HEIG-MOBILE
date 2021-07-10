import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/models/bulletin.dart';

class BulletinProvider {
  Bulletin _bulletin = Bulletin([]);

  BulletinProvider();

  Stream<Bulletin> getBulletin(String username, String password) async* {
    yield _bulletin;
    _bulletin = await ApiController().fetchNotes(username, password);
    yield _bulletin;
  }
}
