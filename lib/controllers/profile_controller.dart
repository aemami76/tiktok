import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/my_user.dart';

class ProfileController extends GetxController {
  late Rx<MyUser> userId = userIdV.obs;
  final MyUser userIdV;
  ProfileController(this.userIdV);

  final Rx<List<String>> _list = Rx([]);
  List<String> get list => _list.value;

  final Rx<Map<String, dynamic>> _user = Rx({});
  Map<String, dynamic> get user => _user.value;

  int following = 0;
  int follower = 0;
  int like = 0;
  bool isFollowing = false;

  getPosts() {
    Stream<QuerySnapshot<Map<String, dynamic>>> query = FirebaseFirestore
        .instance
        .collection('videos')
        .where('userId', isEqualTo: userId.value.uid)
        .snapshots();
    _list.bindStream(query.map((QuerySnapshot<Map<String, dynamic>> query) {
      List<String> list = [];
      for (var element in query.docs) {
        list.add(element.data()['videoUrl']);
      }
      return list;
    }));
  }

  getMetadata() async {
    var snap1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value.uid)
        .collection('following')
        .get();

    following = snap1.docs.length;

    var snap2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value.uid)
        .collection('follower')
        .get();

    follower = snap2.docs.length;

    var snap3 = await FirebaseFirestore.instance
        .collection('users')
        .doc(MyUser.instance!.uid)
        .collection('following')
        .doc(userId.value.uid)
        .get();

    isFollowing = snap3.exists;

    _user.value = {
      'follower': follower.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
    };

    update();
  }

  follow() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value.uid)
        .collection('follower')
        .doc(MyUser.instance!.uid)
        .set({});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(MyUser.instance!.uid)
        .collection('following')
        .doc(userId.value.uid)
        .set({});
    update();
  }

  unfollow() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value.uid)
        .collection('follower')
        .doc(MyUser.instance!.uid)
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(MyUser.instance!.uid)
        .collection('following')
        .doc(userId.value.uid)
        .delete();

    update();
  }
}
