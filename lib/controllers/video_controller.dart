import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/my_user.dart';
import 'package:tiktok_clone/models/video_model.dart';

class VideoController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);
  Rx<List<VideoModel>> get videoList => _videoList;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(FirebaseFirestore.instance
        .collection('videos')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> query) {
      List<VideoModel> videoList = [];
      for (var element in query.docs) {
        videoList.add(VideoModel.fromJson(element.data()));
      }
      return videoList;
    }));
  }

  likeVideo(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('videos').doc(id).get();
    final myId = MyUser.instance!.uid;

    if ((doc.data()!)['like'].contains(myId)) {
      FirebaseFirestore.instance.collection('videos').doc(id).update({
        'like': FieldValue.arrayRemove([myId])
      });
    } else {
      FirebaseFirestore.instance.collection('videos').doc(id).update({
        'like': FieldValue.arrayUnion([myId])
      });
    }
  }
}
