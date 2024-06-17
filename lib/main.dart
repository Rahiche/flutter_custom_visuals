import 'package:flutter/material.dart';
import 'package:flutter_custom_visuals/ripple/blur_demo.dart';
import 'package:flutter_custom_visuals/ripple/electro_demo.dart';
import 'package:flutter_custom_visuals/ripple/gradient_flow_demo.dart';
import 'package:flutter_custom_visuals/ripple/lightning_demo.dart';
import 'package:flutter_custom_visuals/ripple/meatballs_demo.dart';
import 'package:flutter_custom_visuals/ripple/mesh_gradient_demo.dart';
import 'package:flutter_custom_visuals/ripple/ripple_demo.dart';
import 'package:flutter_custom_visuals/ripple/sparkles_demo.dart';
import 'package:flutter_custom_visuals/ripple/sweep_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterCustomVisuals',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DemoGridPage(),
    );
  }
}

class DemoGridPage extends StatefulWidget {
  const DemoGridPage({super.key});

  @override
  State<DemoGridPage> createState() => _DemoGridPageState();
}

class _DemoGridPageState extends State<DemoGridPage> {
  final examples = [
    "Ripple",
    "BoxBlur",
    "Meatballs",
    "GradientFlow",
    "MeshGradient",
    "Waterr?",
    "Noise?",
    "Sparkles",
    "Stars",
    "PageCurl",
    "lightning",
  ];

  @override
  Widget build(BuildContext context) {
    return GradientFlowDemoPage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Custom Visuals'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: examples.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showDemo(context, examples[index]),
            child: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(examples[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDemo(BuildContext context, String demo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (demo) {
            case "Ripple":
              return const RippleDemoPage();
            case "lightning":
              return const LightningDemoPage();
            case "BoxBlur":
              return const BlurDemoPage();
            case "Meatballs":
              return const MeatballsDemoPage();
            case "GradientFlow":
              return const GradientFlowDemoPage();
            case "MeshGradient":
              return const MeshGradientDemoPage();
            case "Sweep":
              return const SweepDemoPage();
            case "Sparkles":
              return const SparklesDemoPage();
            case "electro":
              return const ElectroDemoPage();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
