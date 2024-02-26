import 'package:cofarmer/common/bottom_bar.dart';
import 'package:cofarmer/common/loading_shimmer.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/providers/location_provider.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 0), () async {
      await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
      await Provider.of<ProposalProvider>(context, listen: false)
          .getProposals();

      await Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation()
          .then((value) => Get.offAll(() => const CustomNavBar()));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoadingEffect.getSearchLoadingScreen(context));
  }
}
