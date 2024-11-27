import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RouteScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng stopLocation;

  RouteScreen({required this.startLocation, required this.stopLocation});

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late GoogleMapController mapController;
  List<LatLng> routePoints = []; // Holds the route points
  List<LatLng> stopPoints = []; // Holds stop points for 10+ min stops

  double totalDistance = 0.0;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _generateRoute(); // Fetch and calculate route details
  }

  void _generateRoute() async {
    // Fetch route between startLocation and stopLocation
    PolylinePoints polylinePoints = PolylinePoints();

    // Replace with your Google Maps Directions API key
    String apiKey = "YOUR_GOOGLE_MAPS_API_KEY";

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(
          widget.startLocation.latitude, widget.startLocation.longitude),
      PointLatLng(widget.stopLocation.latitude, widget.stopLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        routePoints = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      });

      // Calculate distance, duration, and stops (example values, replace with real data)
      setState(() {
        totalDistance = 15.4; // Example value
        totalDuration = Duration(minutes: 30); // Example value
        stopPoints = [LatLng(37.7749, -122.4194)]; // Example stop points
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Location: ${widget.startLocation}'),
                  Text('Stop Location: ${widget.stopLocation}'),
                  Text(
                      'Total Distance: ${totalDistance.toStringAsFixed(2)} KM'),
                  Text('Total Duration: ${totalDuration.inMinutes} minutes'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.startLocation,
                zoom: 12.0,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  color: Colors.blue,
                  width: 5,
                  points: routePoints,
                ),
              },
              markers: {
                Marker(
                  markerId: MarkerId('start'),
                  position: widget.startLocation,
                  infoWindow: InfoWindow(title: 'Start Location'),
                ),
                Marker(
                  markerId: MarkerId('stop'),
                  position: widget.stopLocation,
                  infoWindow: InfoWindow(title: 'Stop Location'),
                ),
                ...stopPoints.map(
                  (stop) => Marker(
                    markerId: MarkerId(stop.toString()),
                    position: stop,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(title: 'Stop Point'),
                  ),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
