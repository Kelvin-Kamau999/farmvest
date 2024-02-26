import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cofarmer/common/custom_textfield.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/models/user_model.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel? user;

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();
  File? imageFile;
  bool isProfilePicUpdate = false;
  List<Media> mediaList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 0), () async {
      await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
      user = Provider.of<AuthProvider>(context, listen: false).user!;
      nameController.text = user!.name!;
      emailController.text = user!.email!;
      phoneController.text = user!.phoneNumber!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    openImagePicker(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: imageFile != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(imageFile!),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: user == null
                                ? null
                                : CachedNetworkImageProvider(user!.profilePic!),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Change Profile Photo',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Your new profile photo will be visible to your investors',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Name',
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: phoneController,
                  hintText: 'Phone',
                ),
              ]),
          Positioned(
              bottom: 30,
              left: 14,
              right: 14,
              child: PrimaryButton(
                  text: 'Save Changes',
                  isLoading: isLoading,
                  onTap: () async {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    if (nameController.text == user!.name &&
                        emailController.text == user!.email &&
                        phoneController.text == user!.phoneNumber) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No changes made'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    final newUser = user!;
                    newUser.name = nameController.text != user!.name!
                        ? nameController.text
                        : user!.name;
                    newUser.email = emailController.text != user!.email!
                        ? emailController.text
                        : user!.email;
                    newUser.phoneNumber =
                        phoneController.text != user!.phoneNumber!
                            ? phoneController.text
                            : user!.phoneNumber;

                    try {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .updateProfile(newUser);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Profile updated successfully'),
                        backgroundColor: kPrimaryColor,
                      ));
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  })),
        ],
      ),
    );
  }

  void openImagePicker(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPicked: (selectedList) {
                        setState(() => mediaList = selectedList);
                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount: MediaCount.multiple,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeText: 'Change',
                      ),
                    )),
              ));
        }).then((_) async {
      if (mediaList.isNotEmpty) {
        setState(() {
          imageFile = mediaList.first.file;
          isProfilePicUpdate = true;
        });

        try {
          await Provider.of<AuthProvider>(context, listen: false)
              .updateProfilePic(mediaList.first.file!);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: kPrimaryColor,
          ));
          setState(() {
            isProfilePicUpdate = false;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to update profile picture'),
            backgroundColor: Colors.red,
          ));
          setState(() {
            isProfilePicUpdate = false;
            imageFile = null;
          });
        }
      }
    });
  }
}
