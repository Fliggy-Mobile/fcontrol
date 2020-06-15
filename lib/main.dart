
import 'package:fcontrol/fcontrol.dart';
import 'package:flutter/material.dart';

import 'fcontroldefine.dart';


void main() {
  // debugProfilePaintsEnabled = true; 
  debugProfileBuildsEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Neumorphism.io'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double fcontrolsize = 200;
  FLightOrientation lightOrientation = FLightOrientation.LeftTop;
  FSurfaceShape surfaceShape = FSurfaceShape.Flat;
  FControlAppearance controlAppearance = FControlAppearance.Neumorphism;
  FControlType controlType = FControlType.Button;
  FGroupController controlController = FGroupController();

  void initState(){
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 85, 185, 243),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child:Center(
          child: FControl(width: 200,height: 200,)),
    ) );
  }
}
