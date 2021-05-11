import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:petfinder/database/announcement_dao.dart';
import 'package:petfinder/models/announcement.dart';

class AnnouncementService {
  AnnouncementDao announcementDao = AnnouncementDao();

  AnnouncementService._privateConstructor();

  static final AnnouncementService _instance =
      AnnouncementService._privateConstructor();

  factory AnnouncementService() {
    return _instance;
  }

  Future<List<String>> saveImagesToStorage(
      List<File> imgList, String id) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    List<String> result = [];
    for (File file in imgList) {
      String imageName = file.path
          .substring(file.path.lastIndexOf('/'), file.path.lastIndexOf('.'))
          .replaceAll('/', '');
      TaskSnapshot snapshot =
          await firebaseStorage.ref().child("$id/$imageName").putFile(file);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        result.add(downloadUrl);
      }
    }
    return result;
  }

  Future<String?> addAnnouncement(Announcement announcement) async {
    return await announcementDao.addAnnouncement(announcement);
  }

  Future<Announcement?> getAnnouncement(String id) async {
    return await announcementDao.getAnnouncement(id);
  }

  Future<List<Announcement>> getAnnouncements(String? text, int? radius,
      Position position, DateTime? from, DateTime? to) async {
    List<Announcement> list = await announcementDao.getAnnouncements();
    List<Announcement> result = [];
    for (Announcement announcement in list) {
      if (whereConditions(announcement, text, radius, position, from, to))
        result.add(announcement);
    }
    return result;
  }

  bool whereConditions(Announcement announcement, String? text, int? radius,
      Position position, DateTime? from, DateTime? to) {
    bool textCondition = (text != null)
        ? (announcement.description.contains(text) ||
            announcement.title.contains(text) ||
            announcement.author_name.contains(text))
        : true;
    bool radiusCondition = true;
    double dist = Geolocator.distanceBetween(announcement.latitude,
        announcement.longitude, position.latitude, position.longitude);
    if (radius != null) {
      if (dist > radius) radiusCondition = false;
    } else {
      if (dist > 1500) radiusCondition = false;
    }
    bool fromCondition =
        (from != null) ? announcement.date.isAfter(from) : true;
    bool toCondition = (from != null) ? announcement.date.isBefore(from) : true;
    return textCondition && radiusCondition && fromCondition && toCondition;
  }

  Future<List<File>> downloadFileExampleAndShare(List<String> imageUrls) async {
    List<File> files = [];
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/share-image.png');
    try {
      await FirebaseStorage.instance
          .ref('pFWbnWCBdCKuwleOSVOp/scaled_image_picker4206801271150943435')
          .writeToFile(downloadToFile);
      files.add(downloadToFile);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    return files;
  }
}
