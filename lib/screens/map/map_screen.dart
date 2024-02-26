import 'package:cached_network_image/cached_network_image.dart';
import 'package:cofarmer/models/proposal_model.dart';
import 'package:cofarmer/providers/location_provider.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:cofarmer/widgets/proposal_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //Needed Variables
  GoogleMapController? _controller;
  final ScrollController _scrollController = ScrollController();
  ProposalModel? selectedProposal;
  final Set<Marker> _markers = <Marker>{};
  bool isInfo = false;

//Map Visual Configuration

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller!.setMapStyle(value);

    final proposals =
        Provider.of<ProposalProvider>(context, listen: false).proposals;

    for (ProposalModel proposal in proposals) {
      _markers.add(
        Marker(
          markerId: MarkerId(proposal.id!),
          onTap: () {
            setState(() {
              selectedProposal = proposal;
            });

            _scrollController.animateTo(
              proposals.indexOf(proposal) *
                      MediaQuery.of(context).size.width *
                      .85 +
                  40,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          //circle to show the mechanic profile in map
          icon: await Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(proposal.images![0]),
              )).toBitmapDescriptor(),
          position:
              LatLng(proposal.location!.latitude, proposal.location!.longitude),
        ),
      );
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    final locData =
        Provider.of<LocationProvider>(context, listen: false).locationData!;
    final proposals =
        Provider.of<ProposalProvider>(context, listen: false).proposals;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(locData.latitude, locData.longitude),
                    zoom: 15),
              ),
            ),
            // const HomeAppBar(),
            Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 80,
                  child: ListView(
                      controller: _scrollController
                        ..addListener(() {
                          if (_scrollController.offset >=
                              _scrollController.position.maxScrollExtent) {
                            int currentIndex = (_scrollController.offset ~/
                                    _scrollController.position.extentInside) +
                                1;

                            _controller!.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(
                                        proposals[currentIndex]
                                            .location!
                                            .latitude,
                                        proposals[currentIndex]
                                            .location!
                                            .longitude),
                                    zoom: 15)));
                          } else {
                            int currentIndex = (_scrollController.offset ~/
                                _scrollController.position.extentInside);

                            _controller!.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(
                                        proposals[currentIndex]
                                            .location!
                                            .latitude,
                                        proposals[currentIndex]
                                            .location!
                                            .longitude),
                                    zoom: 15)));
                          }
                        }),
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        ...List.generate(
                            proposals.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedProposal = proposals[index];
                                      isInfo = true;
                                    });
                                  },
                                  child: Container(
                                    width: 320,
                                    height: 78,
                                    margin: const EdgeInsets.only(right: 15),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: ProposalTile(
                                        proposal: proposals[index]),
                                  ),
                                )),
                      ]),
                )),
          ],
        ),
      ),
    );
  }
}
