import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/my_user.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/views/screens/comment_screen.dart';
import 'package:tiktok_clone/views/widgets/spin_animation.dart';
import 'package:tiktok_clone/views/widgets/video_player_widget.dart';

import '../../controllers/video_controller.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController vc = Get.put(VideoController());

  final user = MyUser.instance!;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          body: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              itemCount: vc.videoList.value.length,
              itemBuilder: (context, index) {
                VideoModel vm = vc.videoList.value[index];
                return Stack(
                  children: [
                    VideoPlayerWidget(vm.thumbUrl),
                    Positioned(
                      right: 20,
                      bottom: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 70,
                            child: Stack(children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(vm.profileUrl),
                              ),
                              const Positioned(
                                right: 0,
                                left: 0,
                                bottom: 5,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: () async {
                              await vc.likeVideo(vm.videoID);
                            },
                            icon: Icon(
                              CupertinoIcons.heart_fill,
                              size: 45,
                              color: vm.like.contains(user.uid)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            vm.like.length.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommentScreen(vm.videoID)));
                            },
                            icon: const Icon(
                              CupertinoIcons.chat_bubble_text,
                              size: 45,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            vm.nComments.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.share,
                              size: 45,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            vm.nShared.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SpinAnimation(
                            child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(user.profileUrl)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 20,
                        left: 20,
                        right: 100,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: Get.width,
                                child: RichText(
                                  text: TextSpan(
                                      style: const TextStyle(fontSize: 26),
                                      children: [
                                        TextSpan(
                                            text: '${vm.username}\n',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        TextSpan(text: vm.caption)
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                );
              }),
        );
      },
    );
  }
}
