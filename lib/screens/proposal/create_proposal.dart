import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/common/custom_textfield.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/screens/proposal/proposal_map_picker.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';

class CreateProposalScreen extends StatefulWidget {
  CreateProposalScreen({super.key});

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final farmName = TextEditingController();

  final description = TextEditingController();

  final titleDeedNumber = TextEditingController();

  final targetAmount = TextEditingController();

  final roi = TextEditingController();

  List<Media> mediaList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Proposal'),
      ),
      body: Stack(
        children: [
          ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  color: kPrimaryColor.withOpacity(0.2),
                  child: const Text(
                    'Fill in all the fields with accurate and relevant information',
                    style: TextStyle(color: kPrimaryColor, fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text('Project information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controller: farmName, hintText: 'Project name'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: description, hintText: 'About the project'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: titleDeedNumber, hintText: 'Title deed number'),
                const SizedBox(
                  height: 14,
                ),
                const Text('Financial information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: targetAmount,
                  hintText: 'Your target amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: roi,
                  hintText: 'Return on investment',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
          Positioned(
            left: 14,
            bottom: 30,
            right: 14,
            child: PrimaryButton(
                text: 'Create Proposal',
                onTap: () {
                  if (farmName.text.isNotEmpty &&
                      description.text.isNotEmpty &&
                      titleDeedNumber.text.isNotEmpty &&
                      targetAmount.text.isNotEmpty &&
                      roi.text.isNotEmpty) {
                    openImagePicker(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill in all the fields'),
                      backgroundColor: Colors.red,
                    ));
                  }
                }),
          ),
        ],
      ),
    );
  }

  void openImagePicker(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
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
        double mediaSize =
            mediaList.first.file!.readAsBytesSync().lengthInBytes /
                (1024 * 1024);

        if (mediaSize < 5.0001) {
          final proposal = ProposalModel(
            description: description.text,
            imageFiles: mediaList.map((e) => e.file!).toList(),
            roi: double.parse(roi.text),
            title: farmName.text,
            targetAmount: targetAmount.text,
            userId: user.userId,
            titleDeedNumber: titleDeedNumber.text,
            ownerName: user.name,
            createdAt: Timestamp.now(),
          );

          Get.to(() => ProposalMapPicker(
                proposal: proposal,
              ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image should be less than 5 MB')));
        }
      }
    });
  }
}
