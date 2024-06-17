import 'dart:ui' as ui;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class SparklesDemoPage extends StatefulWidget {
  const SparklesDemoPage({super.key});

  @override
  State<SparklesDemoPage> createState() => _SparklesDemoPageState();
}

class _SparklesDemoPageState extends State<SparklesDemoPage>
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

  @override
  Widget build(BuildContext context) {
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

                            value += 0.03;
                            canvas.drawRect(
                              Rect.fromLTWH(0, 0, size.width, size.height),
                              Paint()..shader = shader,
                            );
                          },
                          child: Container(),
                        );
                      },
                      assetKey: "shaders/sparkles.frag",
                    );
                  },
                );
              },
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
