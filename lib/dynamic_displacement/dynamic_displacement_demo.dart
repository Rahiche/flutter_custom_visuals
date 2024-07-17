import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class DynamicDisplacementDemo extends StatefulWidget {
  const DynamicDisplacementDemo({super.key});

  @override
  State<DynamicDisplacementDemo> createState() =>
      _DynamicDisplacementDemoState();
}

class _DynamicDisplacementDemoState extends State<DynamicDisplacementDemo>
    with SingleTickerProviderStateMixin {
  Offset _position = const Offset(0, 0);
  Offset _delta = const Offset(0, 0);
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double widgetWidth = 400;
  double widgetHeight = 700;

  void _updatePosition(DragUpdateDetails details) {
    double normalizedX = details.localPosition.dx;
    double normalizedY = details.localPosition.dy;

    double normalizedDeltaX = (details.delta.dx * 65);
    double normalizedDeltaY = (details.delta.dy * 65);

    setState(() {
      _position = Offset(normalizedX, normalizedY);
      if (details.delta != const Offset(0, 0)) {
        _delta = Offset(normalizedDeltaX, normalizedDeltaY);
      }
    });
  }

  void _animateToZero() async {
    _animation = Tween<Offset>(
      begin: _delta,
      end: const Offset(0, 0),
    ).animate(_controller)
      ..addListener(() {
        setState(() => _delta = _animation.value);
      });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, From the Flutter Side'),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: _updatePosition,
        onPanEnd: (_) => _animateToZero(),
        onPanCancel: () => _animateToZero(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addLayer(
                child: Container(
                  width: widgetWidth,
                  height: widgetHeight,
                  color: Colors.black,
                  child: Text(
                    'Hello, world! Hello, from Flutter world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!' *
                        4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addLayer({required Widget child}) {
    return ShaderBuilder(
      (context, shader, _) {
        return AnimatedSampler(
          (image, size, canvas) {
            shader
              ..setFloat(0, _position.dx)
              ..setFloat(1, _position.dy)
              ..setFloat(2, _delta.dx)
              ..setFloat(3, _delta.dy)
              ..setFloat(4, size.width)
              ..setFloat(5, size.height)
              ..setImageSampler(0, image);

            canvas.drawRect(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Paint()..shader = shader,
            );
          },
          child: child,
        );
      },
      assetKey: "shaders/dynamic_displacement_shader.frag",
    );
  }
}
