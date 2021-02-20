
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
const kGoogleApiKey = "AIzaSyC2Ed8NK3U_TNsH74XBu7SUcu89yIw-WhU";


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  Query _ref;
  Position pos;
  GoogleMapController mapController;
  final LatLng _center = const LatLng(19.1514765, 72.8348085);
  final Set<Marker> markers = Set();
  Future<String> currentLocation() async {
    pos=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return 'Location Recieved';
  }
  @override
   initState() {
    super.initState();
      requestPermission();
      _ref=FirebaseDatabase.instance.reference()
    .child('turfdata').orderByChild('Address');
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

  }

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  Widget _buildTurfItem({Map turf}){
    return Container(
      padding: EdgeInsets.all(10),
      height: 90,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

              Text(turf['TurfName'],
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Icon(Icons.location_on_outlined,
                color: Colors.black,
                size: 15,
              ),
              SizedBox(width:6,),
              Column(
                children: [
                  Text(turf['Location'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Icon(Icons.phone_android,
                color: Colors.red,
                size: 15,
              ),
              SizedBox(width:6,),
                  Text(turf['BookingContact'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),

            ],
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Stack(
        children: <Widget>[
          SafeArea(
            child: GoogleMap(
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              mapType: MapType.normal,
              tiltGesturesEnabled: true,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
             markers:Set.from(markers),
                  /*.toSet(),
              onTap: (cordinate){
                mapController.animateCamera(CameraUpdate.newLatLng(cordinate));
                addMarker(cordinate);
              },*/
            ),
          ),
     Positioned(
       top:55,
       left:10,
       right:10,

       child: SearchMapPlaceWidget(
         placeholder: "search",
         placeType:PlaceType.address,
         apiKey: "AIzaSyC2Ed8NK3U_TNsH74XBu7SUcu89yIw-WhU",
         onSelected: (Place place) async {
           Geolocation geolocation = await place.geolocation;
           mapController.animateCamera(CameraUpdate.newLatLng(
             geolocation.coordinates
           ));
           mapController.animateCamera(
             CameraUpdate.newLatLngBounds(geolocation.bounds,0)
           );
         },
       ),
     ),
          Positioned(
            top: 550,
            left: 0,
            right: 0,
            bottom: 0,
            child:FutureBuilder(
              future: currentLocation(),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Center(
                  child:FirebaseAnimatedList(query: _ref,itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
                    Map turf = snapshot.value;
                    double distance=Geolocator.distanceBetween(pos.latitude,pos.longitude,double.parse(turf['Latitude']),double.parse(turf['Longitude']));
                    if(distance>10000){
                      return _buildTurfItem(turf: turf);}
                    else{
                      return CircularProgressIndicator();
                    }
                  },),
                  );
            }
                else{
                  return Center(
                    child:CircularProgressIndicator(),
                  );
                }

    }
    )

          )
        ],
      ),
    );
  }
}
