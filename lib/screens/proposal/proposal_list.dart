import 'package:cofarmer/common/api_service.dart';
import 'package:cofarmer/common/loading_shimmer.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/widgets/proposal_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProposalList extends StatelessWidget {
  ProposalList({super.key, this.isFarmer = false});
  final bool isFarmer;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposals'),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: isFarmer
                ? kProposalsRef.where('userId', isEqualTo: userId).snapshots()
                : kProposalsRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingEffect.getSearchLoadingScreen(context);
              }
              final proposalData = snapshot.data!.docs;
              return ListView.separated(
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) => ProposalTile(
                        proposal:
                            ProposalModel.fromJson(proposalData[index].data()),
                      ),
                  separatorBuilder: (ctx, index) => const Divider(),
                  itemCount: proposalData.length);
            }),
      ),
    );
  }
}
