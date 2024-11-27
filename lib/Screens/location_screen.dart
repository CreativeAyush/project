import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'route_screen.dart'; // Import the RouteScreen

class LocationScreen extends StatefulWidget {
  final String memberName;
  final String memberId;

  LocationScreen({required this.memberName, required this.memberId});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  LatLng currentLocation = LatLng(37.7749, -122.4194);

  // Example visited locations
  List<Map<String, dynamic>> visitedLocations = [
    {
      'time': '08:00 AM',
      'location': 'Point A',
      'lat': 37.7749,
      'lng': -122.4194,
    },
    {
      'time': '10:30 AM',
      'location': 'Point B',
      'lat': 37.7849,
      'lng': -122.4094,
    },
    {
      'time': '01:00 PM',
      'location': 'Point C',
      'lat': 37.7949,
      'lng': -122.4294,
    },
  ];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.memberName} - Location & Route'),
      ),
      body: Column(
        children: [
          // Map showing the current location
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: currentLocation,
                  infoWindow: InfoWindow(
                    title: 'Current Location',
                    snippet:
                        'Lat: ${currentLocation.latitude}, Lon: ${currentLocation.longitude}',
                  ),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          // List of visited locations with navigation to RouteScreen
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Visited Locations (${DateFormat('yyyy-MM-dd').format(selectedDate)})',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 2));
                    },
                    child: ListView.builder(
                      itemCount: visitedLocations.length - 1, // Avoid last item
                      itemBuilder: (context, index) {
                        // Access current and next location
                        final current = visitedLocations[index];
                        final next = visitedLocations[index + 1];
                        return ListTile(
                          leading: Icon(Icons.location_on, color: Colors.red),
                          title: Text(
                              '${current['location']} → ${next['location']}'),
                          subtitle:
                              Text('${current['time']} → ${next['time']}'),
                          trailing:
                              Icon(Icons.arrow_forward, color: Colors.blue),
                          onTap: () {
                            // Navigate to RouteScreen with current and next location
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RouteScreen(
                                  startLocation: LatLng(
                                    current['lat'],
                                    current['lng'],
                                  ),
                                  stopLocation: LatLng(
                                    next['lat'],
                                    next['lng'],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
