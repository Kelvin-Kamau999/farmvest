import 'package:cofarmer/common/bottom_bar.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PostProposalProgress extends StatefulWidget {
  const PostProposalProgress({super.key, required this.proposal});
  final ProposalModel proposal;

  @override
  State<PostProposalProgress> createState() => _PostProposalProgressState();
}

class _PostProposalProgressState extends State<PostProposalProgress> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 0), () async {
      try {
        await Provider.of<ProposalProvider>(context, listen: false)
            .createProposal(widget.proposal);
        setState(() {
          isLoading = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const CustomNavBar());
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => isLoading ? false : true,
        child: Column(
          children: [
            const Spacer(),
            Lottie.asset('assets/upload.json'),
            const Spacer(),
            Text(
                isLoading ? 'Uploading proposal... DO NOT EXIT' : "Upload done",
                style: TextStyle(
                    color: isLoading ? Colors.grey : kPrimaryColor,
                    fontWeight: isLoading ? null : FontWeight.bold)),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
