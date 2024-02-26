import 'package:cofarmer/common/cached_image.dart';
import 'package:cofarmer/common/utils.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/screens/proposal_details/proposal_details_screen.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class ProposalTile extends StatelessWidget {
  const ProposalTile({
    super.key,
    required this.proposal,
  });
  final ProposalModel proposal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProposalDetailsScreen(proposal: proposal)),
      child: SizedBox(
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: cachedImage(
                proposal.images![0],
                height: 70,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proposal.title!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 6,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: FractionallySizedBox(
                      widthFactor: proposal.currentAmount! /
                          double.parse(proposal.targetAmount!),
                      child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      proposalStat(
                          icon: Iconsax.coin,
                          title: "${proposal.roi!}% ROI",
                          color: kPrimaryColor),
                      const SizedBox(
                        width: 14,
                      ),
                      proposalStat(
                          icon: Iconsax.timer,
                          title: getCreatedAt(proposal.createdAt!)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
