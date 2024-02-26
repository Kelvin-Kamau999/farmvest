import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/common/loading_shimmer.dart';
import 'package:cofarmer/models/notification_model.dart';
import 'package:cofarmer/screens/notifications/notification_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';
  NotificationsScreen({Key? key}) : super(key: key);

  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userData')
              .doc(uid)
              .collection('notifications')
              .where('createdAt', isNull: false)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text('No Notifications'),
              );
            }
            return ListView(
                children: List.generate(
                    docs.length,
                    (index) => NotificationsTile(
                          notification:
                              NotificationsModel.fromJson(docs[index]),
                        )));
          }),
    );
  }
}