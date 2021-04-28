import 'package:petfinder/database/user_dao.dart';
import 'package:petfinder/models/user_custom.dart';

class UserService {
  UserDao userDao = UserDao();

  late UserCustom userCustom;

  UserService._privateConstructor();

  static final UserService _instance = UserService._privateConstructor();

  factory UserService() {
    return _instance;
  }

  Future<UserCustom?> registerUser(UserCustom user) {
    return userDao.addUser(user);
  }

  Future<UserCustom?> getUser(String email) {
    return userDao.getUser(email);
  }

  Future<UserCustom?> addGoogleUser(UserCustom user) async {
    UserCustom? userGoogle = await getUser(user.email);
    if (userGoogle == null) {
      userGoogle = await registerUser(user);
    }
    return userGoogle;
  }

  Future<bool> updateUser(UserCustom user) {
    return userDao.updateUser(user);
  }

  setCustomUser(UserCustom user) {
    userCustom = user;
  }
}
