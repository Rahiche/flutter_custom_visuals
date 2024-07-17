import 'package:flutter/material.dart';
import 'package:flutter_custom_visuals/dynamic_displacement/dynamic_displacement_demo.dart';
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
        itemCount: 2,
        itemBuilder: (context, index) {
          if (index == 0) {
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
          } else if (index == 1) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DynamicDisplacementDemo(),
                  ),
                );
              },
              child: Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Dynamic Displacement"),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
