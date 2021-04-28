import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petfinder/models/follow.dart';

//This documents represents a bunch of widgets to do the Firestore queries

class FollowDao {
  Future<List<Follow>> getFollowsForUser(String email) async {
    List<Follow> list = [];
    await FirebaseFirestore.instance
        .collection('follows')
        .where('user_email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Follow follow = Follow.fromJson(doc.data());
        follow.id = doc.id;
        list.add(follow);
      }
    });
    return list;
  }

  Future<Follow?> addFollow(Follow follow) async {
    Follow? result;
    await FirebaseFirestore.instance
        .collection('follows')
        .add(follow.toJson())
        .then((DocumentReference reference) async {
      await reference.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          result = Follow.fromJson(documentSnapshot.data()!);
          result!.id = documentSnapshot.id;
        }
      });
    });
    return result;
  }

  Future<bool> removeFollow(String id) async {
    bool result = false;
    await FirebaseFirestore.instance
        .collection('follows')
        .doc(id)
        .delete()
        .then((value) => result = true)
        .catchError((onError) => result = false);
    return result;
  }
}
