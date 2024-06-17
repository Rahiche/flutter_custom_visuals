import 'dart:ui' as ui;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class GradientFlowDemoPage extends StatefulWidget {
  const GradientFlowDemoPage({super.key});

  @override
  State<GradientFlowDemoPage> createState() => _GradientFlowDemoPageState();
}

class _GradientFlowDemoPageState extends State<GradientFlowDemoPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  double value = 0;

  int currentColorSetIndex = 0;

  final List<Map<String, Color>> colorSets = [
    {
      'colorPrimary': Color(0xFFFDF5E6), // Old Lace
      'colorSecondary': Color(0xFFC0392B), // Dark Red
      'colorAccent1': Color(0xFFFFE4E1), // Misty Rose
      'colorAccent2': Color(0xFF2980B9), // Dark Sky Blue
    },
    {
      'colorPrimary': Color(0xFFFFDAB9), // Peach Puff
      'colorSecondary': Color(0xFF000080), // Navy
      'colorAccent1': Color(0xFFFFFAF0), // Floral White
      'colorAccent2': Color(0xFF2E8B57), // Sea Green
    },
    {
      'colorPrimary': Color(0xFFFAFAD2), // Light Goldenrod Yellow
      'colorSecondary': Color(0xFF2C3E50), // Dark Blue
      'colorAccent1': Color(0xFFFFF8DC), // Cornsilk
      'colorAccent2': Color(0xFF27AE60), // Dark Green
    },
    {
      'colorPrimary': Color(0xFFFFE4C4), // Bisque
      'colorSecondary': Color(0xFF7F8C8D), // Dark Gray
      'colorAccent1': Color(0xFFFFFAF0), // Floral White
      'colorAccent2': Color(0xFFC0392B), // Dark Red
    },
    {
      'colorPrimary': Color(0xFFFFF0F5), // Lavender Blush
      'colorSecondary': Color(0xFF8E44AD), // Dark Purple
      'colorAccent1': Color(0xFFFFF8E1), // Beige
      'colorAccent2': Color(0xFFE67E22), // Dark Orange
    },
    {
      'colorPrimary': Color(0xFFFFFACD), // Lemon Chiffon
      'colorSecondary': Color(0xFF2C3E50), // Dark Blue
      'colorAccent1': Color(0xFFF0FFFF), // Azure
      'colorAccent2': Color(0xFF16A085), // Dark Teal
    },

    // dark
    {
      'colorPrimary': Color(0xFF2C3E50), // Dark Blue
      'colorSecondary': Color(0xFF8E44AD), // Dark Purple
      'colorAccent1': Color(0xFF2980B9), // Dark Sky Blue
      'colorAccent2': Color(0xFF27AE60), // Dark Green
    },

    {
      'colorPrimary': Color(0xFF34495E), // Dark Slate Blue
      'colorSecondary': Color(0xFFD35400), // Dark Orange
      'colorAccent1': Color(0xFF16A085), // Dark Teal
      'colorAccent2': Color(0xFF2ECC71), // Dark Green
    },
  ];

  void _changeColorSet() {
    setState(() {
      currentColorSetIndex = (currentColorSetIndex + 1) % colorSets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentColorSet = colorSets[currentColorSetIndex];
    final colorPrimary = currentColorSet['colorPrimary']!;
    final colorSecondary = currentColorSet['colorSecondary']!;
    final colorAccent1 = currentColorSet['colorAccent1']!;
    final colorAccent2 = currentColorSet['colorAccent2']!;

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: DeviceFrame(
          device: Devices.ios.iPhone13ProMax,
          isFrameVisible: true,
          orientation: Orientation.portrait,
          screen: Scaffold(
            body: PageView.builder(
              itemBuilder: (BuildContext context, int index) {
                return AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return ShaderBuilder(
                      (context, shader, _) {
                        return AnimatedSampler(
                          (image, size, canvas) {
                            shader.setFloat(0, size.width);
                            shader.setFloat(1, size.height);
                            shader.setFloat(2, value);

                            shader.setFloat(3, colorPrimary.red / 255);
                            shader.setFloat(4, colorPrimary.green / 255);
                            shader.setFloat(5, colorPrimary.blue / 255);

                            shader.setFloat(6, colorSecondary.red / 255);
                            shader.setFloat(7, colorSecondary.green / 255);
                            shader.setFloat(8, colorSecondary.blue / 255);

                            shader.setFloat(9, colorAccent1.red / 255);
                            shader.setFloat(10, colorAccent1.green / 255);
                            shader.setFloat(11, colorAccent1.blue / 255);

                            shader.setFloat(12, colorAccent2.red / 255);
                            shader.setFloat(13, colorAccent2.green / 255);
                            shader.setFloat(14, colorAccent2.blue / 255);

                            value += 0.02;
                            canvas.drawRect(
                              Rect.fromLTWH(0, 0, size.width, size.height),
                              Paint()..shader = shader,
                            );
                          },
                          child: Container(),
                        );
                      },
                      assetKey: "shaders/gradient_flow.frag",
                    );
                  },
                );
              },
            ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flexible(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       currentColorSet.toString(),
                //       maxLines: 5,
                //     ),
                //   ),
                // ),
                FloatingActionButton(
                  onPressed: _changeColorSet,
                  child: Icon(Icons.color_lens),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShaderHelper {
  static void configureShader(
    ui.FragmentShader shader,
    ui.Size size,
    ui.Image image, {
    required double time,
    required Offset pointer,
  }) {
    shader
      ..setFloat(0, size.width) // iResolution
      ..setFloat(1, size.height) // iResolution
      ..setFloat(2, pointer.dx) // iMouse
      ..setFloat(3, pointer.dy) // iMouse
      ..setFloat(4, time) // iTime
      ..setImageSampler(0, image); // image
  }

  static void drawShaderRect(
    ui.FragmentShader shader,
    ui.Size size,
    ui.Canvas canvas,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      Paint()..shader = shader,
    );
  }
}
