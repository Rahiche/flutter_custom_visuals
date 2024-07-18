import 'package:flutter/material.dart';
import 'package:flutter_custom_visuals/dynamic_displacement/dynamic_displacement_demo.dart';
import 'package:flutter_custom_visuals/ripple/ripple_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterCustomVisuals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemoGridPage(),
    );
  }
}

class DemoGridPage extends StatelessWidget {
  const DemoGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Custom Visuals'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    builder: (context) => const RippleDemoPage(),
                  ),
                );
              },
              child: const Card(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
                    builder: (context) => const DynamicDisplacementDemo(),
                  ),
                );
              },
              child: const Card(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
