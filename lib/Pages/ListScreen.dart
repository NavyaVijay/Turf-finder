import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:geolocator/geolocator.dart';
import 'DetailScreen.dart';

class ListScreen extends StatefulWidget {
  // Declare a field that holds the Todo.


  // In the constructor, require a Todo.
 

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Query _ref;
  Position pos;
  Future<String> currentLocation() async {
    pos=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return 'Location Recieved';
  }
  @override
  initState()  {
    super.initState();
    _ref=FirebaseDatabase.instance.reference()
        .child('turfdata');

  }
  Widget _buildTurfItem1({Map turf}){

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
        height: 150,
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
            SizedBox(height: 5,),
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
          ],
        ),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
      title:Text("ListView"),
      ),
      body: Stack(
        children: [
          Positioned(
              top:0,
              left: 5,
              right: 5,
              bottom:0,
              child:FutureBuilder(

                  future: currentLocation(),
                  builder: (BuildContext context,AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      return Center(
                        child:FirebaseAnimatedList(query: _ref,itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double>animation,int index,
                            ){
                          Map turf = snapshot.value;

                          double distance=Geolocator.distanceBetween(pos.latitude,pos.longitude,double.parse(turf['Latitude']),double.parse(turf['Longitude']));
                          if((distance/1000)>20){
                            Map turf1=snapshot.value;
                            turf1.putIfAbsent('Distance', () => (distance/1000).toString()+' km');
                            return _buildTurfItem1(turf: turf);}
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
        ],
      ),
    );


  }
  
}