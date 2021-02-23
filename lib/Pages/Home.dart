
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

import 'DetailScreen.dart';
import 'ListScreen.dart';
const kGoogleApiKey = "AIzaSyC2Ed8NK3U_TNsH74XBu7SUcu89yIw-WhU";


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  double width,height;
  Query _ref;
  GoogleMapController mapController;
  Position pos;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }
  Future<String> currentLocation() async {
    pos=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return 'Location Recieved';
  }
  @override
   initState() {
    super.initState();
      requestPermission();
      _ref=FirebaseDatabase.instance.reference()
    .child('turfdata');
  }



  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  Widget _buildTurfItem({Map turf}){
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(turf:turf),
          ),
        );
      },
    child:Container(
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
    
      
      child:Column(
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
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Icon(Icons.airport_shuttle,
                color: Colors.red,
                size: 15,
              ),
              SizedBox(width:6,),
              Text(turf['Distance'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),

            ],
          ),

 ]
    ),
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
            top:0,
            bottom: 0,
            right: 0,
            left:0,
            child:  GoogleMap(
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:LatLng(19.0760,72.8777),
              zoom: 20.0,
            ),
          ),),
          Positioned(
            top: 0,
            right: 0,
            left:0,
            bottom:0,
            child:FutureBuilder(
            future: currentLocation(),
    builder: (BuildContext context,AsyncSnapshot snapshot){
    if(snapshot.hasData){
      return Center(
        child:
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target:LatLng(pos.latitude,pos.longitude),
            zoom:10.0,
          ),

        ),
      );

    }
            else{
              return Center(
            child: CircularProgressIndicator(),
              );
            }
    }
            ),),

          Positioned(
            top:(MediaQuery.of(context).size.height)/2+20,
            left:(MediaQuery.of(context).size.width)/2+20,
              right: 10,
              child: ElevatedButton(
                child: Text('ListView'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListScreen(),
                    ),
                  );
                },
              )
          ),
          Positioned(
              top:(MediaQuery.of(context).size.height)/2+70,
              left: 5,
              right: 5,
              bottom:0,
            child:FutureBuilder(

              future: currentLocation(),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Center(
                  child:FirebaseAnimatedList(query: _ref, scrollDirection:Axis.horizontal,itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index,
                      ){
                    Map turf = snapshot.value;

                    double distance=Geolocator.distanceBetween(pos.latitude,pos.longitude,double.parse(turf['Latitude']),double.parse(turf['Longitude']));
                    if((distance/1000)>20){
                      Map turf1= snapshot.value;
                      turf1.putIfAbsent('Distance', () => (distance/1000).toString()+' km');
                      return _buildTurfItem(turf: turf1);}

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
        ],
      ),
    );
  }
}
