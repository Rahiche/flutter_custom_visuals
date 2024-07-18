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

  void _updatePosition(DragUpdateDetails details) {
    double normalizedX = details.localPosition.dx;
    double normalizedY = details.localPosition.dy;

    double normalizedDeltaX = (details.delta.dx * 55).clamp(-400, 400);
    double normalizedDeltaY = (details.delta.dy * 55).clamp(-400, 400);

    setState(() {
      _position = Offset(normalizedX, normalizedY);
      if (details.delta != const Offset(0, 0)) {
        _delta = Offset.lerp(
          _delta,
          Offset(normalizedDeltaX, normalizedDeltaY),
          0.1,
        )!;
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
    final isMobile = MediaQuery.sizeOf(context).width < 500;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onPanUpdate: _updatePosition,
              onPanEnd: (_) => _animateToZero(),
              child: addLayer(
                child: Column(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 4 : 48.0),
                        child: Container(
                          color: Colors.black,
                          child: const Text(
                            """In realms where light and shadow play,
Shaders weave the night and day,
With code that dances, twists, and gleams,
They craft the fabric of our dreams.

Each pixel speaks in hues and tones,
A symphony of whispered zones,
Through matrices and vectors fine,
They paint the world in arcs divine.

In Flutter's embrace, they find their grace,
Animating with vibrant pace,
From shadows deep to highlights bright,
They bring our visions into light.

So here's to shaders, artists bold,
With Flutter's tools, their stories told,
In lines of code, they shape the skies,
A digital dawn before our eyes.""",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
