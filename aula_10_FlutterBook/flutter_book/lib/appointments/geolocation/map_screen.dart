import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(-15.7942, -47.8822); // Localização de BSB
  String _selectedAddress = "Tap on the map to select a location";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  Future<void> _onMapTapped(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address = "${place.street}, ${place.locality}, ${place.country}";

      setState(() {
        _selectedAddress = address;
        _currentPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select location")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: (LatLng position) => _onMapTapped(position),
              markers: {
                Marker(
                  markerId: MarkerId("selected_location"),
                  position: _currentPosition,
                  infoWindow: InfoWindow(title: "Selected location"),
                ),
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(_selectedAddress, textAlign: TextAlign.center),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedAddress);
                  },
                  child: Text("Confirm location"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
