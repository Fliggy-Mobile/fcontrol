import 'package:fcontrol/fcontrol.dart';
import 'package:fcontrol/fdefine.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FControl Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FControl(
              width: 200,
              height: 80,
              color: _color,
              corner: FCorner.all(16),
              onTapCallback: (_, __) {
                setState(() {
                  _color = _color == Colors.blue ? Colors.purple : Colors.blue;
                });
              },
              child: const Center(
                child: Text(
                  'Tap me',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 50),
            FControl(
              width: 200,
              height: 80,
              gradient: const LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blue],
              ),
              corner: FCorner.all(16),
              child: const Center(
                child: Text(
                  'Gradient',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
