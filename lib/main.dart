import 'package:flutter/material.dart';
import 'package:flutter_custom_visuals/ripple/ripple_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterCustomVisuals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DemoGridPage(),
    );
  }
}

class DemoGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Custom Visuals'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 1,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RippleDemoPage(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Ripple"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
