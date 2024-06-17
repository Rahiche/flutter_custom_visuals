import 'dart:ui' as ui;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class MeatballsDemoPage extends StatefulWidget {
  const MeatballsDemoPage({super.key});

  @override
  State<MeatballsDemoPage> createState() => _MeatballsDemoPageState();
}

class _MeatballsDemoPageState extends State<MeatballsDemoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            body: Center(child: Bubbles()),
          ),
        ),
      ),
    );
  }

  Offset _pointer = Offset.zero;

  void _updatePointer(PointerEvent details) {
    // _controller.animateTo(1.0);
    _controller.reset();
    _controller.forward();
    setState(() {
      _pointer = details.localPosition;
    });
  }

  Widget buildImage() {
    return Listener(
      onPointerMove: _updatePointer,
      onPointerDown: _updatePointer,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderBuilder(
            (context, shader, _) {
              return AnimatedSampler(
                (image, size, canvas) {
                  ShaderHelper.configureShader(
                    shader,
                    size,
                    image,
                    time: _controller.value * 10.0,
                    pointer: _pointer,
                  );
                  ShaderHelper.drawShaderRect(shader, size, canvas);
                },
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/palm_tree_cropped.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            assetKey: "shaders/ripple.frag",
          );
        },
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

class Bubbles extends StatefulWidget {
  const Bubbles({Key? key}) : super(key: key);

  @override
  State<Bubbles> createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {
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
  double count = 0.01;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final child = Center(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return ShaderBuilder(
            (context, shader, child) {
              return AnimatedSampler(
                (image, size, canvas) {
                  // Set the values for resolution and iTime
                  shader.setFloat(0, size.width * 2);
                  shader.setFloat(1, size.height * 2);
                  shader.setFloat(2, value);
                  shader.setFloat(3, count);

                  value += 0.03;
                  canvas.drawRect(
                    Rect.fromLTWH(0, 0, size.width, size.height),
                    Paint()..shader = shader,
                  );
                },
                child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                ),
              );
            },
            assetKey: 'shaders/bubbles.frag',
          );
        },
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Center(
          //   child: FilledButton(
          //     onPressed: () {
          //       count = count + 0.001;
          //       setState(() {});
          //     },
          //     child: const Text(
          //       "Click here",
          //       style: TextStyle(fontSize: 40),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
