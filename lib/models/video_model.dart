class VideoModel {
  String userId;
  String videoID;
  String username;
  String profileUrl;
  String thumbUrl;
  String videoUrl;
  String caption;
  List like;
  int nComments;
  int nShared;

  VideoModel(
      {required this.userId,
      required this.videoID,
      required this.username,
      required this.profileUrl,
      required this.thumbUrl,
      required this.videoUrl,
      required this.caption,
      required this.like,
      required this.nComments,
      required this.nShared});

  static VideoModel fromJson(Map<String, dynamic> map) => VideoModel(
      userId: map['userId'],
      videoID: map['videoID'],
      username: map['username'],
      profileUrl: map['profileUrl'],
      thumbUrl: map['thumbUrl'],
      videoUrl: map['videoUrl'],
      caption: map['caption'],
      like: map['like'],
      nComments: map['nComments'],
      nShared: map['nShared']);
}
