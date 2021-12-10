import '../../models/bulletin.dart';
import '../../models/horaires.dart';
import '../../models/menu_jour.dart';
import '../../models/user.dart';

abstract class IAPI {
  Future<Horaires> fetchHoraires(String username, String password, int gapsId,
      {bool decrypt = false});

  Future<Bulletin> fetchNotes(String username, String password, int gapsId,
      {int year = 2020, bool decrypt = false});

  Future<List<MenuJour>> fetchMenuSemaine();

  Future<String> fetchPublicKey();

  Future<User> fetchUser(String username, String password, int gapsId,
      {bool decrypt = false});

  Future<int> login(String username, String password, {bool decrypt = false});
}
