import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/Home.dart';
import 'Size/SizeConfig.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(
        builder: (context,constraints){

          return OrientationBuilder(
              builder: (context,orientation){
                SizeConfig().init(constraints, orientation);
                return  MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home :  Home(),
                    color: Colors.cyan[600],
                    title: 'Turf Finder',
                    routes:{

                      //'/search':(context)=>Search(),


                    }
                );
              }
          );
        }
    );
  }
}


