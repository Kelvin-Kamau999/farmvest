import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget cachedImage(
  String url, {
  double? width,
  double? height,
  BoxFit? fit,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: fit,
    progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        height: height,
        width: width,
        // color: Colors.grey,
        child: const MyShimmer(
          child: Icon(
            Icons.handyman,
            color: Colors.grey,
          ),
        )),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

class MyShimmer extends StatelessWidget {
  const MyShimmer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.blueGrey,
        highlightColor: Colors.blueGrey.withOpacity(0.2),
        enabled: true,
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 3000),
        child: child);
  }
}
