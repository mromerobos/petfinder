import 'package:petfinder/database/follow_dao.dart';
import 'package:petfinder/models/follow.dart';

class FollowService {
  FollowDao followDao = FollowDao();

  FollowService._privateConstructor();

  static final FollowService _instance = FollowService._privateConstructor();

  factory FollowService() {
    return _instance;
  }

  Future<Follow?> isFollowAnnounce(String email, String id) async {
    List<Follow> list = await followDao.getFollowsForUser(email);
    Follow? result;
    for (Follow follow in list) {
      if (follow.announce_id == id) {
        result = follow;
      }
    }
    return result;
  }

  Future<Follow?> followAnnouncement(String email, String id) async {
    Follow? result =
        await followDao.addFollow(Follow(email, id, DateTime.now()));
    return result;
  }

  Future<bool> unFollowAnnouncement(String id) async {
    return await followDao.removeFollow(id);
  }
}
