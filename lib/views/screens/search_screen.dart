import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';

import '../../models/my_user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  List<MyUser> list = [];
  searchUser(String user) async {
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: user)
        .get();
    for (var element in snap.docs) {
      list.add(MyUser.fromJson(element.data()));
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Search',
            focusedBorder: InputBorder.none,
          ),
          onSubmitted: (val) {
            searchUser(val);
            print(val);
          },
        ),
      ),
      body: list.isEmpty
          ? const Center(
              child: Text(
                'Search for a User',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(list[index])));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(list[index].profileUrl),
                    ),
                    title: Text(list[index].username),
                  )),
    );
  }
}
