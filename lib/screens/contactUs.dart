//import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String _mapStyle;
  final Map<String, Marker> _markers = {};
  GoogleMapController mapController;
  final LatLng _center = const LatLng(51.5149058, -0.1236213);

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
    setState(() {
      _markers.clear();
      final marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(20),
        markerId: MarkerId("Kraken Global Ltd."),
        position: LatLng(51.5149058, -0.1236213),
        infoWindow: InfoWindow(
            title: "Kraken Global Ltd.",
            snippet:
                "Kraken Global Ltd71-75 Shelton Street Covent GardenLondon WC2H 9JQ Contact+44 (0) 2080 888886"),
      );
      _markers["Kraken Global Ltd."] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact Us"),
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 12),
              ),
              child: GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.3,
                ),
                markers: _markers.values.toSet(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_img.png'),
                alignment: Alignment.topLeft,
                ),
                color: Colors.black87,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RichText(
                    text: TextSpan(text: "Address\n\n", style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold),children: <TextSpan>[
                      TextSpan(text: "71-75 Shelton Street\nCovent Garden\nLondon WC2H 9JQ",style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      TextSpan(text: "\n\n\nMap",style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold)),
                    ]),textAlign: TextAlign.start,
                    softWrap: true,
                  ),RichText(
                    text: TextSpan(text: "Contact\n\n", style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold),children: <TextSpan>[
                      TextSpan(text: "+44(0)2080 888886\ncontact@kraken.global",style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      TextSpan(text: "\nwww.kraken.global\n\n\n",style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.bold)),
                    ]),textAlign: TextAlign.left,
//                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
