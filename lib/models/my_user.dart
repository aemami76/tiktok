class MyUser {
  String uid;
  String username;
  String email;
  String profileUrl;

  MyUser(
      {required this.uid,
      required this.username,
      required this.email,
      required this.profileUrl});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'profileUrl': profileUrl
      };

  static MyUser fromJson(Map<String, dynamic> map) {
    return MyUser(
        uid: map['uid'],
        username: map['username'],
        email: map['email'],
        profileUrl: map['profileUrl']);
  }

  static MyUser? instance;
}
