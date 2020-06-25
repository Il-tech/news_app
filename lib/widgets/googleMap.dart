import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleDoc extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<GoogleDoc> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(33.579784, -7.620114);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final Set<Marker> _markers = {};
  @override
  void initState() {
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: 'Emsi centre',
        snippet: 'casa',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void _onAddMarkerButtonPressed() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_center.toString()),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(
          title: 'here i m',
          snippet: '' +
              currentLocation.latitude.toString() +
              ',' +
              currentLocation.longitude.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<void> moveTo() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final position = LatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 18,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18.0,
            ),
            markers: _markers,
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
            padding: const EdgeInsets.all(32.0),
            child: Align(
                alignment: Alignment.topRight,
                   child: Column(children: <Widget>[
                    FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    tooltip: 'Get location',
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.indigo,
                    child: const Icon(Icons.flag, size: 48.0),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: moveTo,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.indigo,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                ])))
      ]),
    );
  }
}

