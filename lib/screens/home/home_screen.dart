import 'package:cofarmer/common/api_service.dart';
import 'package:cofarmer/common/cached_image.dart';
import 'package:cofarmer/common/loading_shimmer.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/location_provider.dart';
import 'package:cofarmer/screens/home/home_top_proposals.dart';
import 'package:cofarmer/screens/proposal/proposal_list.dart';
import 'package:cofarmer/widgets/proposal_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: kTextTabBarHeight,
          ),
          const Text('CoFarmer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text(
            'Explore',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: StreamBuilder(
                stream: kProposalsRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingEffect.getSearchLoadingScreen(context);
                  }
                  final proposalData = snapshot.data!.docs;
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 14),
                    children: [
                      HomeRow(
                        proposals: proposalData
                            .map((e) => ProposalModel.fromJson(e.data()))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(children: [
                        const Text(
                          'Latest proposals',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Get.to(() => ProposalList()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text('View all'),
                          ),
                        )
                      ]),
                      const SizedBox(
                        height: 14,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) => ProposalTile(
                                proposal: ProposalModel.fromJson(
                                    proposalData[index].data()),
                              ),
                          separatorBuilder: (ctx, index) => const Divider(),
                          itemCount: proposalData.length)
                    ],
                  );
                }),
          )
        ],
      ),
    ));
  }
}
