import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petfinder/models/comment.dart';

//This documents represents a bunch of widgets to do the Firestore queries

class CommentDao {
  Future<String?> addComment(Comment comment) async {
    String? result;
    await FirebaseFirestore.instance
        .collection('comments')
        .add(comment.toJson())
        .then((DocumentReference reference) {
      result = reference.id;
    });
    return result;
  }

  Future<Comment?> getComment(String id) async {
    Comment? result;
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = Comment.fromJson(documentSnapshot.data()!);
        result!.id = documentSnapshot.id;
      }
    });
    return result;
  }

  Future<List<Comment>> getComments(String id) async {
    List<Comment> list = [];
    await FirebaseFirestore.instance
        .collection('comments')
        .where('announce_id', isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Comment comment = Comment.fromJson(doc.data());
        comment.id = doc.id;
        list.add(comment);
      }
    });
    return list;
  }
}
