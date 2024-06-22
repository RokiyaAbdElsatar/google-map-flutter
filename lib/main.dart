import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};

  late GoogleMapController mapController;
  final LatLng _kMapCenter =  LatLng(62.82002179405264, 6.873241812062004);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final displayStations = await locations.getStations();
    setState(() {
      _markers.clear();
      for (final station in displayStations.stations) {
        final marker = Marker(
            markerId: MarkerId(station.name),
            position: LatLng(station.lat, station.lng),
            infoWindow:
            InfoWindow(title: station.name, snippet: station.address));
        _markers[station.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:  Center(
              child: Text(
                  'Google Map',
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 30
                ),
              )),
          backgroundColor: Colors.green,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _kMapCenter,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}