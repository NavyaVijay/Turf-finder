
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
  double width,height;
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
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      height: 90,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0,3),
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

              Text(turf['TurfName'],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Icon(Icons.location_on_outlined,
                color: Colors.black,
                size: 15,
              ),
              SizedBox(width:12,),
              Column(
                children: [
                  Text(turf['Location'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 10,),
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
  Widget _buildTurfItem1({Map turf}){
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      height: 120,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0,3),
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(turf['TurfName'],
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Icon(Icons.location_on_outlined,
                color: Colors.black,
                size: 15,
              ),
              SizedBox(width:12,),
              Column(
                children: [
                  Text(turf['Location'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 10,),
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
      appBar: AppBar(
        title: const Text("Turf Finder"),
      ),

      body:Stack(
        children: <Widget>[

          Positioned(
            top:10,
            left:10,
              right: 0,


              child: Text("Turfs Near You",style: TextStyle(fontWeight: FontWeight.bold),)
          ),
          Positioned(
              top:40,
              left: 5,
              right: 5,
              bottom:(MediaQuery.of(context).size.height)/2+70,
            child:FutureBuilder(
              future: currentLocation(),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Center(
                  child:FirebaseAnimatedList(query: _ref, scrollDirection:Axis.horizontal,itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){

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

          ),
          Positioned(
            top:(MediaQuery.of(context).size.height)/2-140,
              left:10,
              right: 0,
              bottom:(MediaQuery.of(context).size.height)/2+40,
              child: Text("All Turfs",style: TextStyle(fontWeight: FontWeight.bold),)
          ),
         Positioned(
         top:(MediaQuery.of(context).size.height)/2-110,
          left: 5,
          right: 5,
         bottom: 0,

         child:FirebaseAnimatedList(query: _ref,itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index){
           Map turf1 = snapshot.value;
           return _buildTurfItem1(turf: turf1);
    }),)
        ],
      ),
    );
  }
}
