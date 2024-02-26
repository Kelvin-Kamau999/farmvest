import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/location_provider.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:cofarmer/screens/proposal/post_proposal_progress.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';

class ProposalMapPicker extends StatelessWidget {
  const ProposalMapPicker({super.key, required this.proposal});
  final ProposalModel proposal;

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    final locData =
        Provider.of<LocationProvider>(context, listen: false).locationData!;
    return Scaffold(
        body: FlutterLocationPicker(
            initPosition: LatLong(locData.latitude, locData.longitude),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            ),
            selectLocationButtonText: 'Confirm project address',
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: true,
            onError: (e) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString()))),
            onPicked: (pickedData) async {
              proposal.address = pickedData.address;
              proposal.location = GeoPoint(
                  pickedData.latLong.latitude, pickedData.latLong.longitude);
              Get.off(() => PostProposalProgress(
                    proposal: proposal,
                  ));
            }));
  }
}
