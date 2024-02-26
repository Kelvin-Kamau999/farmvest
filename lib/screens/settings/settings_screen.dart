import 'package:cached_network_image/cached_network_image.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/screens/auth/auth_screen.dart';
import 'package:cofarmer/screens/notifications/notification_screen.dart';
import 'package:cofarmer/screens/proposal/proposal_list.dart';
import 'package:cofarmer/screens/settings/edit_profile.dart';
import 'package:cofarmer/screens/settings/help_screen.dart';
import 'package:cofarmer/screens/settings/investments_screen.dart';
import 'package:cofarmer/screens/settings/privacy_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  List<Map> privacySettings = [
    {
      'title': 'Notifications',
      'icon': Icons.security_outlined,
      "onTap": () => Get.to(() => NotificationsScreen())
    },
    {
      'title': 'Privacy & Security',
      'icon': Icons.lock_outline,
      "onTap": () => Get.to(() => const PrivacySettings())
    },
  ];

  List<Map> misc = [
    {
      'title': 'Help & Support',
      'icon': Icons.help_outline,
      "onTap": () => Get.to(() => const HelpScreen())
    },
    {
      'title': 'About',
      'icon': Icons.info_outline,
      "onTap": () {
        launchUrl(Uri.parse('https://cofarmer.ke/'));
      },
    },
    {
      'title': 'Logout',
      'icon': Icons.close,
      'onTap': () {
        FirebaseAuth.instance.signOut();
        Get.offAll(() => const AuthScreen());
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    List<Map> personalSettings = [
      {
        'title': 'Edit profile',
        'icon': Icons.person_outline,
        "onTap": () => Get.to(() => EditProfileScreen())
      },
      {
        'title': 'Investments',
        'icon': Icons.notifications_none_outlined,
        "onTap": () => Get.to(() => const InvestmentsScreen())
      },
      if (user.userType!.toLowerCase() == 'farmer')
        {
          'title': 'Your proposals',
          'icon': Icons.check_box_outlined,
          "onTap": () => Get.to(() => ProposalList(isFarmer: false))
        }
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shrinkWrap: true,
        children: [
          ListTile(
            onTap: () => Get.to(() => EditProfileScreen()),
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(
                user.profilePic!,
              ),
            ),
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(user.name!),
            subtitle: Text(user.userType == 'farmer' ? 'Farmer' : 'Investor'),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          SettingSection(children: personalSettings),
          const SizedBox(
            height: 14,
          ),
          SettingSection(children: privacySettings),
          const SizedBox(
            height: 14,
          ),
          SettingSection(children: misc),
        ],
      ),
    );
  }
}

class SettingSection extends StatelessWidget {
  const SettingSection({super.key, required this.children});

  final List<Map> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => SizedBox(
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            onTap: () => children[index]['onTap'](),
            leading: Icon(
              children[index]['icon'],
              color: Colors.grey,
            ),
            title: Text(
              children[index]['title'],
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
