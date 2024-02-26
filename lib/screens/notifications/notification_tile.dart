import 'package:cofarmer/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:intl/intl.dart';

class NotificationsTile extends StatelessWidget {
  const NotificationsTile({Key? key, required this.notification})
      : super(key: key);
  final NotificationsModel notification;
  String dateCreated() {
    //If date is less than today return the date else return the time
    if (DateTime.now().difference(notification.createdAt!.toDate()).inDays >
        0) {
      return DateFormat('dd/MM/yyy').format(notification.createdAt!.toDate());
    } else {
      return DateFormat('HH:mm a').format(notification.createdAt!.toDate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: CachedNetworkImageProvider(
                      notification.imageUrl!,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(child: Text(notification.message!)),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            )
          ],
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              dateCreated(),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ))
      ],
    );
  }
}
