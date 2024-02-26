import 'package:cofarmer/common/cached_image.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/screens/proposal_details/proposal_details_screen.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class HomeRow extends StatelessWidget {
  const HomeRow({
    super.key,
    required this.proposals,
  });
  final List<ProposalModel> proposals;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 240,
      child: ListView.separated(
        itemCount: proposals.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 14,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () =>
              Get.to(() => ProposalDetailsScreen(proposal: proposals[index])),
          child: SizedBox(
            width: size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: cachedImage(
                    proposals[index].images![0],
                    height: 150,
                    width: size.width * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  proposals[index].title!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'By: ${proposals[index].ownerName!}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Row(
                  children: [
                    proposalStat(
                        icon: Iconsax.coin,
                        title: "${proposals[index].roi!}% ROI",
                        color: kPrimaryColor),
                    const SizedBox(
                      width: 14,
                    ),
                    proposalStat(
                        icon: Iconsax.user,
                        title: proposals[index].numberOfContibutors.toString()),
                    const SizedBox(
                      width: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
