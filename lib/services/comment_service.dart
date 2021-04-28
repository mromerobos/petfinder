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

  Future<List<Comment>> getComments(String id) async {
    return await commentDao.getComments(id);
  }
}