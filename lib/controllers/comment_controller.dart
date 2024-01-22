import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/my_user.dart';

import '../models/comment_model.dart';

class CommentController extends GetxController {
  final user = MyUser.instance!;
  final Rx<List<CommentModel>> _cList = Rx([]);

  List<CommentModel> get cList => _cList.value;

  like(String cId, String pId) async {
    var snap = await FirebaseFirestore.instance
        .collection('videos')
        .doc(pId)
        .collection('comments')
        .doc(cId)
        .get();
    print('>>>>>>>>>>>>>>>>>${snap.data()}');
    List<dynamic> data = (snap.data() as Map<String, dynamic>)['like'];
    if (data.contains(user.uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(pId)
          .collection('comments')
          .doc(cId)
          .update({
        'like': FieldValue.arrayRemove([user.uid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(pId)
          .collection('comments')
          .doc(cId)
          .update({
        'like': FieldValue.arrayUnion([user.uid])
      });
    }
  }

  showComment(String postId) {
    var cStream = FirebaseFirestore.instance
        .collection('videos')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> query) {
      List<CommentModel> list = [];
      for (var q in query.docs) {
        list.add(CommentModel.fromJson(q.data()));
      }
      return list;
    });

    _cList.bindStream(cStream);
  }

  Future<void> postComment(
      {required String caption, required String postId}) async {
    try {
      if (caption.isNotEmpty) {
        var commentUid = DateTime.now().toString();
        await FirebaseFirestore.instance
            .collection('videos')
            .doc(postId)
            .collection('comments')
            .doc(commentUid)
            .set({
          'username': user.username,
          'userId': user.uid,
          'userProfileUrl': user.profileUrl,
          'comment': caption,
          'commentId': commentUid,
          'postId': postId,
          'like': [],
          'dateTime': DateTime.now()
        });

        await FirebaseFirestore.instance
            .collection('videos')
            .doc(postId)
            .update({'nComments': FieldValue.increment(1)});
      }
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }
}
