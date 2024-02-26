import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  final GeoPoint? location;
  final String? city;
  final String? country;
  final String? street;
  final String? postalCode;
  final String? state;
  final String? address;

  UserLocation(
      {this.location,
      this.city,
      this.country,
      this.address,
      this.street,
      this.postalCode,
      this.state});

  Map<String, dynamic> toJson() {
    return {
      'location': GeoPoint(location?.latitude ?? 0, location?.longitude ?? 0),
      'city': city,
      'country': country,
      'street': street,
      'postalCode': postalCode,
      'state': state,
      'address': address,
    };
  }

  factory UserLocation.fromJson(dynamic json) {
    return UserLocation(
      location: json['location'],
      city: json['city'],
      country: json['country'],
      street: json['street'],
      postalCode: json['postalCode'],
      state: json['state'],
      address: json['address'],
    );
  }
}

class LocationProvider with ChangeNotifier {
  double? _longitude;
  double? _latitude;
  double? get longitude => _longitude;
  double? get latitude => _latitude;
  Position? _locationData;
  Position? get locationData {
    return _locationData;
  }

  UserLocation? _userLocation;
  UserLocation? get userLocation {
    return _userLocation;
  }

  final List<Map<String, dynamic>> _addressList = [];
  Future<void> getCurrentLocation() async {
    //using location package
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final locData = await Geolocator.getCurrentPosition();
    _locationData = locData;

    GeoCode geoCode = GeoCode();

    final coordinates = await geoCode.reverseGeocoding(
        latitude: locData.latitude, longitude: locData.longitude);

    _userLocation = UserLocation(
      city: coordinates.city,
      country: coordinates.countryName,
      street: coordinates.streetAddress,
      postalCode: coordinates.postal,
      address: coordinates.streetAddress,
      state: coordinates.region,
      location: GeoPoint(locData.latitude, locData.longitude),
    );

    notifyListeners();
  }

  List preferredUserLocations({Map<String, dynamic>? locations}) {
    final currentLocation = {
      'title': 'Current Location',
      'address': userLocation!.address,
    };
    if (locations != null) {
      _addressList.add(locations);
    }
    return [
      currentLocation,
      ..._addressList,
    ];
  }

  Future<UserLocation> getLocationDetails(LatLng loc) async {
    GeoCode geoCode = GeoCode();

    final coordinates = await geoCode.reverseGeocoding(
        latitude: _locationData!.latitude, longitude: _locationData!.longitude);

    return UserLocation(
      city: coordinates.city,
      country: coordinates.countryName,
      street: coordinates.streetAddress,
      postalCode: coordinates.postal,
      address: coordinates.streetAddress,
      state: coordinates.region,
      location: GeoPoint(_locationData!.latitude, _locationData!.longitude),
    );
  }
}
