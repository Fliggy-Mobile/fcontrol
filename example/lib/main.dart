import 'package:fbutton/fbutton.dart';
import 'package:fcontrol/fcontrol.dart';
import 'package:fcontrol/finnershadow.dart';
import 'package:flutter/material.dart';
import 'package:fsuper/fsuper.dart';

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
  Color color = Colors.blue;
  Color backgroundColor = Colors.white;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        backgroundColor: Color.fromARGB(255, 85, 185, 243),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: FControl(
                  color: backgroundColor,
                  child: FSuper(
                    width: 100,
                    height: 100,
                    corner: Corner.all(100),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            FButton(
              text: "Change",
              style: TextStyle(color: Colors.white),
              padding: EdgeInsets.all(9.0),
              color: Colors.blue[200],
              onPressed: () {
                setState(() {
                  color = Colors.purple;
                  backgroundColor = Colors.yellow;
                });
              },
              effect: true,
            ),
            const SizedBox(height: 50.0),
          ],
        ));
  }
}
