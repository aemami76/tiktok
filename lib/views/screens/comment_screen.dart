import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/comment_controller.dart';
import 'package:tiktok_clone/models/my_user.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(this.postId, {super.key});
  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final controller = TextEditingController();
  CommentController cc = Get.put(CommentController());

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        cc.showComment(widget.postId);
        return ListView.builder(
            itemCount: cc.cList.length,
            itemBuilder: (context, index) {
              var cIndex = cc.cList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(cIndex.userProfileUrl),
                ),
                title: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '${cIndex.username}  ',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: '${cIndex.comment}\n')
                ])),
                subtitle: Text(
                    '${cIndex.dateTime.toDate().toString().substring(0, 10)}  ${cIndex.likes.length} likes'),
                trailing: IconButton(
                  onPressed: () {
                    cc.like(cIndex.commentId, cIndex.postId);
                  },
                  icon: cIndex.likes.contains(MyUser.instance!.uid)
                      ? const Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                        )
                      : const Icon(CupertinoIcons.heart),
                ),
              );
            });
      }),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Comment here',
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
                width: 50,
                child: TextButton(
                    onPressed: () async {
                      await cc.postComment(
                          caption: controller.text, postId: widget.postId);

                      setState(() {
                        controller.text = '';
                      });
                    },
                    child: const Text('Post'))),
          ],
        ),
      ),
    );
  }
}
