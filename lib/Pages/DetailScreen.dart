import 'dart:async';


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:search_map_place/search_map_place.dart';
const kGoogleApiKey = "AIzaSyC2Ed8NK3U_TNsH74XBu7SUcu89yIw-WhU";

class DetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final Map turf;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.turf}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  GoogleMapController mapController;

  String searchAddr;
  Set<Marker> _markers = Set<Marker>();

  @override
  initState()  {
    super.initState();
    requestPermission();

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("0"),
          position: LatLng(double.parse(widget.turf['Latitude']),double.parse(widget.turf['Longitude'])),
          icon:BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: widget.turf['TurfName']
          )
        ),
      );
    });

  }

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left:0,
            bottom: (MediaQuery.of(context).size.height)/2+40,
            child:
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target:LatLng(double.parse(widget.turf['Latitude']),double.parse(widget.turf['Longitude'])),
              zoom: 20.0,
            ),
          ),),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(5.0),
              color: Colors.white,
              width: 500.0,
              height: 40.0,

              alignment: Alignment.center,
              child: Text(widget.turf['TurfName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top:  (MediaQuery.of(context).size.height)/2-110,
            left: 0,
            right: 0,
            bottom: 0,
             // width: double.infinity,
              child:SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('Address'),
                        subtitle: Text(widget.turf['Address']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.sports_baseball),
                        title: Text('Ball'),
                        subtitle: Text(widget.turf['Ball']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.phone_iphone_outlined),
                        title: Text('Booking Contact'),
                        subtitle: Text(widget.turf['BookingContact']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.money),
                        title: Text('Pricing'),
                        subtitle: Text(widget.turf['Pricing']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.local_parking),
                        title: Text('Parking'),
                        subtitle: Text(widget.turf['Parking']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Turf Type'),
                        subtitle: Text(widget.turf['Turftype']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Sitting Stand'),
                        subtitle: Text(widget.turf['SittingStand']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Ground Size'),
                        subtitle: Text(widget.turf['Groundsize']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Goalpost Size'),
                        subtitle: Text(widget.turf['Goalpostsize']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Coaching'),
                        subtitle: Text(widget.turf['Coaching']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Beverages'),
                        subtitle: Text(widget.turf['Beverages']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Bibs'),
                        subtitle: Text(widget.turf['Bibs']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Online Booking Availability'),
                        subtitle: Text(widget.turf['Online booking Avalability']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Preferred Format'),
                        subtitle: Text(widget.turf['PreferredFormat']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Preferred Studs'),
                        subtitle: Text(widget.turf['Preferredstuds']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Unique Feature'),
                        subtitle: Text(widget.turf['UniqueFeature']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Washroom'),
                        subtitle: Text(widget.turf['Washroom']),

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('Water'),
                        subtitle: Text(widget.turf['Water']),

                      ),
                    ),

                  ],
                ),
              ),
            ),


        ],
      ),

    );
  }
}
