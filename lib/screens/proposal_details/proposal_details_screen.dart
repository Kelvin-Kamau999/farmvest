import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/common/api_service.dart';
import 'package:cofarmer/common/cached_image.dart';
import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/common/utils.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/models/user_model.dart';
import 'package:cofarmer/providers/chat_provider.dart';
import 'package:cofarmer/screens/chat/chat_room.dart';
import 'package:cofarmer/screens/proposal_details/investment_modal.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProposalDetailsScreen extends StatefulWidget {
  const ProposalDetailsScreen({super.key, required this.proposal});
  final ProposalModel proposal;

  @override
  State<ProposalDetailsScreen> createState() => _ProposalDetailsScreenState();
}

class _ProposalDetailsScreenState extends State<ProposalDetailsScreen> {
  UserModel? farmer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 0), () async {
      farmer = await kUsersRef.doc(widget.proposal.userId).get().then((farmer) {
        return UserModel.fromJson(farmer.data()!);
      });
      setState(() {
        farmer = farmer;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    width: double.infinity,
                    child: cachedImage(widget.proposal.images![0],
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Colors.white,
                              Colors.white.withOpacity(0)
                            ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.proposal.title!,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Initiated by: ${widget.proposal.ownerName!}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Raised so far',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text(
                              'KES ${moneyFormat(widget.proposal.currentAmount!.toString())}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Target',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text(
                              'KES ${moneyFormat(widget.proposal.targetAmount!)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: widget.proposal.currentAmount! /
                            double.parse(widget.proposal.targetAmount!),
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        proposalStat(
                            icon: Iconsax.coin,
                            title: "${widget.proposal.roi!}% ROI",
                            color: kPrimaryColor),
                        const SizedBox(
                          width: 14,
                        ),
                        proposalStat(
                            icon: Iconsax.user,
                            title:
                                widget.proposal.numberOfContibutors.toString()),
                        const SizedBox(
                          width: 14,
                        ),
                        proposalStat(
                            icon: Iconsax.timer,
                            title: getCreatedAt(widget.proposal.createdAt!)),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      widget.proposal.description!,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: farmer != null
                            ? CachedNetworkImageProvider(farmer!.profilePic!)
                            : null,
                      ),
                      title: Text(farmer != null ? farmer!.name! : 'Farmer'),
                      subtitle: const Text('Farmer'),
                      trailing: InkWell(
                          onTap: () async {
                            final users = Provider.of<ChatProvider>(context,
                                    listen: false)
                                .contactedUsers;
                            List<String> room = users.map<String>((e) {
                              return e.chatRoomId!.contains(
                                      '${FirebaseAuth.instance.currentUser!.uid}_${farmer!.userId!}')
                                  ? '${FirebaseAuth.instance.currentUser!.uid}_${farmer!.userId!}'
                                  : '${farmer!.userId!}_${FirebaseAuth.instance.currentUser!.uid}';
                            }).toList();

                            await kUsersRef
                                .doc(farmer!.userId)
                                .get()
                                .then((value) {
                              Navigator.of(context)
                                  .pushNamed(ChatRoom.routeName, arguments: {
                                'user': UserModel.fromJson(value.data()!),
                                'chatRoomId': room.isEmpty
                                    ? '${FirebaseAuth.instance.currentUser!.uid}_${farmer!.userId!}'
                                    : room.first,
                              });
                            });
                          },
                          child: const Icon(Iconsax.message)),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'Location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ProjectLocationCard(
                      proposal: widget.proposal,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 20,
              left: 14,
              right: 14,
              child: Builder(builder: (context) {
                return PrimaryButton(
                  text: 'Start investment',
                  onTap: () {
                    showBottomSheet(
                        context: context,
                        elevation: 10,
                        builder: (context) => InvestmentModal(
                              proposal: widget.proposal,
                            ));
                  },
                );
              }))
        ],
      ),
    );
  }
}

class ProjectLocationCard extends StatelessWidget {
  const ProjectLocationCard({
    super.key,
    required this.proposal,
  });
  final ProposalModel proposal;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  proposal.location!.latitude, proposal.location!.longitude),
              zoom: 15),
        ));
  }
}

Row proposalStat({String? title, IconData? icon, Color? color}) {
  return Row(
    children: [
      Icon(
        icon ?? Iconsax.location,
        size: 14,
        color: color ?? Colors.grey,
      ),
      const SizedBox(
        width: 4,
      ),
      Text(
        title!,
        style: TextStyle(color: color ?? Colors.black, fontSize: 12),
      ),
    ],
  );
}
