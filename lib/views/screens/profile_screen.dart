import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/models/my_user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(this.myUser, {super.key});
  final MyUser myUser;
  @override
  Widget build(BuildContext context) {
    final ProfileController pc = Get.put(ProfileController(myUser));
    pc.getMetadata();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: Text(myUser.username),
        centerTitle: true,
        actions: const [Icon(Icons.more_vert_outlined)],
      ),
      body: GetBuilder<ProfileController>(
          init: null,
          builder: (controller) {
            if (pc.user['following'] == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Obx(() {
                pc.getPosts();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(myUser.profileUrl),
                        radius: 70,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: pc.user['follower'] + '\n',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: '\nfollowers',
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: pc.user['following'] + '\n',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: '\nfollowing',
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: '0\n',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                  text: '\nlikes',
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      myUser.uid == MyUser.instance!.uid
                          ? OutlinedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                              },
                              style: OutlinedButton.styleFrom(),
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 26),
                              ))
                          : pc.user['isFollowing']
                              ? OutlinedButton(
                                  onPressed: () {
                                    pc.unfollow();
                                  },
                                  style: OutlinedButton.styleFrom(),
                                  child: const Text(
                                    'UnFollow',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 26),
                                  ))
                              : OutlinedButton(
                                  onPressed: () {
                                    pc.follow();
                                  },
                                  style: OutlinedButton.styleFrom(),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 26),
                                  )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(),
                      GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: pc.list.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: Get.width / 2.5,
                                  height: Get.width / 2.5,
                                  child: Image.network(
                                    pc.list[index],
                                    fit: BoxFit.fill,
                                  )),
                            );
                          })
                    ],
                  ),
                );
              });
            }
          }),
    );
  }
}
