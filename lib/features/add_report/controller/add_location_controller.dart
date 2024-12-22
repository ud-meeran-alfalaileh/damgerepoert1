import 'dart:async';

import 'package:damgerepoert/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/src/google_maps_webservice/src/places.dart'
    as hoc_places;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart';

class LocationController extends GetxController {
  var latitude = 0.0.obs;
  RxBool isAdded = false.obs;
  var longitude = 0.0.obs;
  final branchName = TextEditingController();
  var markers = <String, Marker>{}.obs;
  Completer<GoogleMapController> controller = Completer();

  GoogleMapController? mapController;

  final location = Location();
  late LatLng initialPosition =
      const LatLng(31.900883058179527, 35.9346984671693);

  CameraPosition get kGooglePlex => const CameraPosition(
        target: LatLng(33.298037, 44.2879251),
        zoom: 10,
      );

  Future<void> handleSearch(BuildContext context) async {
    try {
      // Display search UI
      hoc_places.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyCJd4BGxCKDB6fhdYCVym7ZM7dM_8w0HuI",
        mode: Mode.overlay, // Can also be Mode.fullscreen
        hint: 'Search for a location...',
        language: 'en',
        textStyle: const TextStyle(color: Colors.black),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        backArrowIcon: Icon(
          Icons.arrow_back,
          color: AppColor.mainAppColor,
        ),
      );

      if (p != null) {
        // Convert hoc_places.Prediction to places.Prediction
        final placesPrediction = places.Prediction(
          placeId: p.placeId,
          description: p.description,
          // matchedSubstrings: p.matchedSubstrings,
          // terms: p.terms,
          types: p.types,
        );

        // Call displayPrediction
        displayPrediction(placesPrediction, context);
      }
    } catch (e) {
      print("Error during search: $e");
    }
  }

  void onError(places.PlacesAutocompleteResponse response) {
    Get.snackbar(
      'Message',
      response.errorMessage!,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
      colorText: Colors.red,
    );
  }

  Future<void> displayPrediction(
      places.Prediction p, BuildContext context) async {
    places.GoogleMapsPlaces place = places.GoogleMapsPlaces(
      apiKey: "AIzaSyCJd4BGxCKDB6fhdYCVym7ZM7dM_8w0HuI",
      apiHeaders: await const header.GoogleApiHeaders().getHeaders(),
    );
    places.PlacesDetailsResponse detail =
        await place.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    latitude.value = lat;
    longitude.value = lng;

    markers.clear(); // Clear old markers and set the new one
    final marker = Marker(
      markerId: const MarkerId('deliveryMarker'),
      position: LatLng(lat, lng),
      infoWindow: const InfoWindow(
        title: '',
      ),
    );
    markers['myLocation'] = marker;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
  }

  void goToPosition(Position position) async {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
    } else if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied permission
    } else {
      try {
        Position position = await Geolocator.getCurrentPosition();
        initialPosition = LatLng(position.latitude, position.longitude);

        goToPosition(position);

        markers.clear(); // Clear old markers and set the new one
        final marker = Marker(
          markerId: const MarkerId('deliveryMarker'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: '',
          ),
        );
        markers['myLocation'] = marker;
      } catch (e) {
        print("Error getting current location: $e");
      }
    }
  }

  @override
  void onInit() {
    getCurrentLocation();
    super.onInit();
  }
}
