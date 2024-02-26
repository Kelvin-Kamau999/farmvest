import 'package:cofarmer/utils/constants.dart';

import 'package:flutter/material.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({Key? key}) : super(key: key);

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    List<Map> privacyOptions = [
      {
        'title': 'Biometric authentication',
        'subtitle':
            'Use biometric authentication(FaceID, TouchID or fingerprint access) to sign in',
        'onTap': () {},
      },
      {
        'title': 'Share my location',
        'subtitle':
            'Share your location to make your recommendations more personal',
        'onTap': () {},
      },
      {
        'title': 'Remember Me',
        'subtitle': 'Remember your user details for faster sign in and access',
        'onTap': () {},
      },
      {
        'title': 'Update Notifications',
        'subtitle':
            'Get notified about promotions, important updates and features',
        'onTap': () {},
      },
      {
        'title': 'Sessions',
        'subtitle':
            'Log out of all sessions and clear all data in all logged in devices',
        'onTap': () {},
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Security'),
        elevation: 0.4,
      ),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        ...List.generate(
          5,
          (index) => PrivacySettingWidget(
            privacyOptions[index]['title'],
            privacyOptions[index]['subtitle'],
            privacyOptions[index]['onTap'],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}

class PrivacySettingWidget extends StatefulWidget {
  const PrivacySettingWidget(this.title, this.subtitle, this.onTap,
      {super.key});
  final String title;
  final String subtitle;
  final Function onTap;

  @override
  State<PrivacySettingWidget> createState() => _PrivacySettingWidgetState();
}

class _PrivacySettingWidgetState extends State<PrivacySettingWidget> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          value: isSwitched,
          title: Text(widget.title),
          subtitle: Text(
            widget.subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          activeColor: kPrimaryColor,
          onChanged: (val) {
            setState(() {
              isSwitched = val;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
