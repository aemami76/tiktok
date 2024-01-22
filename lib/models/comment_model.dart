import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String userId;
  String userProfileUrl;
  String comment;
  String commentId;
  String postId;
  List likes;
  Timestamp dateTime;

  CommentModel(
      {required this.username,
      required this.userId,
      required this.userProfileUrl,
      required this.comment,
      required this.commentId,
      required this.postId,
      required this.likes,
      required this.dateTime});

  static CommentModel fromJson(Map<String, dynamic> map) => CommentModel(
      username: map['username'],
      userId: map['userId'],
      userProfileUrl: map['userProfileUrl'],
      comment: map['comment'],
      commentId: map['commentId'],
      postId: map['postId'],
      likes: map['like'],
      dateTime: map['dateTime']);
}
