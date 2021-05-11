import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petfinder/database/announcement_dao.dart';
import 'package:petfinder/database/comment_dao.dart';
import 'package:petfinder/models/announcement.dart';
import 'dart:io';

import 'package:petfinder/models/comment.dart';

class CommentService {
  CommentDao commentDao = CommentDao();

  CommentService._privateConstructor();

  static final CommentService _instance = CommentService._privateConstructor();

  factory CommentService() {
    return _instance;
  }

  Future<String?> addComment(Comment comment) async {
    return await commentDao.addComment(comment);
  }

  Future<Comment?> getComment(String id) async {
    return await commentDao.getComment(id);
  }

  Future<List<Comment>> getCommentsForAnnouncement(String id) async {
    List<Comment> result = await commentDao.getCommentsForAnnouncement(id);
    result.sort((a, b) => (a.date.isBefore(b.date))? 1 : 0);
    return result;
  }

  Future<List<Comment>> getComments(List<Announcement> listAnn) async {
    List<String> announcements_ids = [];
    for(Announcement announcement in listAnn) {
      announcements_ids.add(announcement.id);
    }
    List<Comment> result = [];
    List<Comment> comments = await commentDao.getComments();
    for(Comment comment in comments) {
      if(announcements_ids.contains(comment.announce_id)) result.add(comment);
    }
    return result;
  }
}