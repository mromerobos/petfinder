import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petfinder/models/announcement.dart';

//This documents represents a bunch of widgets to do the Firestore queries

class AnnouncementDao {
  Future<String?> addAnnouncement(Announcement announcement) async {
    String? announce;
    await FirebaseFirestore.instance
        .collection('announcements')
        .add(announcement.toJson())
        .then((DocumentReference reference) {
      announce = reference.id;
    });
    return announce;
  }

  Future<Announcement?> getAnnouncement(String id) async {
    Announcement? result;
    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = Announcement.fromJson(documentSnapshot.data()!);
        result!.id = documentSnapshot.id;
      }
    });
    return result;
  }

  Future<List<Announcement>> getAnnouncements() async {
    List<Announcement> list = [];
    await FirebaseFirestore.instance
        .collection('announcements')
        .get()
        .then((QuerySnapshot snapshot) {
          for(QueryDocumentSnapshot document in snapshot.docs) {
            Announcement announcement = Announcement.fromJson(document.data());
            announcement.id = document.id;
            list.add(announcement);
          }
    });
    return list;
  }
}
