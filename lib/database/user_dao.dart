import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petfinder/models/user_custom.dart';

//This documents represents a bunch of widgets to do the Firestore queries

class UserDao {
  Future<UserCustom?> addUser(UserCustom userInfo) async {
    UserCustom? user;
    await FirebaseFirestore.instance
        .collection('users')
        .add(userInfo.toJson())
        .then((DocumentReference value) {
      user = UserCustom.fromJson(userInfo.toJson());
      user!.id = value.id;
    });
    return user;
  }

  Future<UserCustom?> getUser(String email) async {
    UserCustom? user;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        user = UserCustom.fromJson(snapshot.docs.first.data());
        user!.id = snapshot.docs.first.id;
      }
    });
    return user;
  }

  Future<bool> updateUser(UserCustom userInfo) async {
    bool error = false;
    if (userInfo.id != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.id)
          .update(userInfo.toJson())
          .catchError((onError) => error = true);
    }
    return error;
  }
}
