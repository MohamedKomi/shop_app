import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_a/screens/create_profile.dart';

class ProfileScreen extends StatefulWidget {
  static const routName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;

  Future<String> getId() async {
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('userId').toString();
    return uid;
  }

  @override
  void initState() {
    getId().then((value) {
      userId = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userId == null
        ? Center(
            child: Text("no data"),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (ctx, AsyncSnapshot snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              DocumentSnapshot docs = snapShot.data;
              Map<String, dynamic> userData =
                  docs.data() as Map<String, dynamic>;

              return Scaffold(
                body: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2, top: 5),
                                child: Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userData['image_url']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 53,
                            backgroundColor: Colors.white,
                            child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(userData['image_url']),
                                      fit: BoxFit.cover),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      userData['name'],
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      userData['bio'],
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      userData['phone'],
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: const [
                                  Text(
                                    '100',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: const [
                                  Text(
                                    '120',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Photos',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: const [
                                  Text(
                                    '100k',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: const [
                                  Text(
                                    '160',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Add Photos',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
  }
}
