import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;
import 'package:shared_preferences/shared_preferences.dart';

class Profile with ChangeNotifier {
  File? coverImage;
  var coverPicker = ImagePicker();
  String? userId;

  Future<void> getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId').toString();
  }

  void getCoverImage() async {
    getId();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);

      print(pickedFile.path);
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }

  void uploadCover({
    required String name,
    required String phone,
    required String bio,
  }) async {
    Firebase_Storage.FirebaseStorage.instance
        .ref()
        .child('users/$userId')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((val) {
        FirebaseFirestore.instance.collection('users').doc(userId).set(
          {
            'name': name,
            'phone': phone,
            'bio': bio,
            'image_url': val,
          },
        );
      }).catchError((error) {});
    }).catchError((error) {});
    notifyListeners();

  }
}
