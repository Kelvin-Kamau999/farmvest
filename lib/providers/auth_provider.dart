import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    await getCurrentUser();
    notifyListeners();
  }

  Future<void> signUp(UserModel userModel) async {
    final userCredentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.email!, password: userModel.password!);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    userModel.userId = uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toJson());
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      _user = UserModel.fromJson(value);
    });
    // await FirebaseMessaging.instance.getToken().then((token) {
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .update({'pushToken': token});
    // });
    notifyListeners();
  }

  Future<void> updateProfile(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userModel.toJson());
    notifyListeners();
  }

  Future<void> updateProfilePic(File pic) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final uploadTask = await FirebaseStorage.instance
        .ref('users/$uid/profile_pic')
        .putFile(pic);

    final url = await uploadTask.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'profilePic': url,
    });
    await getCurrentUser();
    notifyListeners();
  }
}
