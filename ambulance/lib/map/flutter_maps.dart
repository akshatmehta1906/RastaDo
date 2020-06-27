import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class flutterMap extends StatefulWidget {
  @override
  _flutterMapState createState() => _flutterMapState();
}

class _flutterMapState extends State<flutterMap> {

  MapController controller = MapController();
  double _latitude = 19.1334;
  double _longitude = 72.9133;

  buildMap(){
    return controller.move(LatLng(_latitude, _longitude), 5.0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(center: LatLng(_latitude, _longitude), minZoom: 15.0),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          MarkerLayerOptions(markers: [
            Marker(
                point: LatLng(_latitude, _longitude),
                builder: (context) => Container(
                  child: IconButton(icon: Icon(Icons.location_on, color: Colors.red,), onPressed: null,  iconSize: 45.0,),
                )
            )
          ]),
        ],
      ),
    );
  }
}
