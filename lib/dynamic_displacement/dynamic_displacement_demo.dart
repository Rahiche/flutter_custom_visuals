import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:sprung/sprung.dart';

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
  final scrollController = ScrollController();

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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Sprung.overDamped,
      ),
    )..addListener(() {
        setState(() => _delta = _animation.value);
      });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    bool showSidebar = MediaQuery.sizeOf(context).width > 500;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Row(
          children: [
            if (showSidebar) buildPlayground(),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: addLayer(
                        child: GestureDetector(
                          onPanUpdate: _updatePosition,
                          onPanEnd: (_) => _animateToZero(),
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    // height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            heroTag: "Down",
                            child: const Text(
                              "↓",
                              style: TextStyle(fontSize: 40),
                            ),
                            onPressed: () {
                              scrollController.animateTo(
                                scrollController.offset + 250,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linearToEaseOut,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          FloatingActionButton(
                            heroTag: "Up",
                            child: const Text(
                              "↑",
                              style: TextStyle(fontSize: 40),
                            ),
                            onPressed: () {
                              scrollController.animateTo(
                                scrollController.offset - 250,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linearToEaseOut,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayground() {
    const min = -1000.0;
    const max = 1000.0;

    return Expanded(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Playground'),
              const Divider(),
              Text('Position.x ${_position.dx}'),
              Slider(
                value: _position.dx,
                onChanged: (value) {
                  setState(() {
                    _position = Offset(value, _position.dy);
                  });
                },
                min: min,
                max: max,
              ),
              Text('Position.y ${_position.dy}'),
              Slider(
                value: _position.dy,
                onChanged: (value) {
                  setState(() {
                    _position = Offset(_position.dx, value);
                  });
                },
                min: min,
                max: max,
              ),
              const Divider(),
              Text('Delta.x ${_delta.dx}'),
              Slider(
                value: _delta.dx,
                onChanged: (value) {
                  setState(() {
                    _delta = Offset(value, _delta.dy);
                  });
                },
                min: min,
                max: max,
              ),
              Text('Delta.y ${_delta.dy}'),
              Slider(
                value: _delta.dy,
                onChanged: (value) {
                  setState(() {
                    _delta = Offset(_delta.dx, value);
                  });
                },
                min: min,
                max: max,
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _position = Offset(
                      min + (max - min) * Random().nextDouble(),
                      min + (max - min) * Random().nextDouble(),
                    );
                    _delta = Offset(
                      min + (max - min) * Random().nextDouble(),
                      min + (max - min) * Random().nextDouble(),
                    );
                  });
                },
                child: const Text('Random Position and Delta'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  const step = 20.0;
                  const dxDelta = (max - min) / step;
                  const dyDelta = (max - min) / step;
                  setState(() {
                    _position = const Offset(0, 0);
                  });
                  Timer.periodic(const Duration(milliseconds: 100), (timer) {
                    if (_position.dx >= max && _position.dy >= max) {
                      timer.cancel();
                    } else {
                      setState(() {
                        _position = Offset(
                          (_position.dx + dxDelta).clamp(min, max),
                          (_position.dy + dyDelta).clamp(min, max),
                        );
                      });
                    }
                  });
                },
                child: const Text('Animate to Bottom Right'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  const double max = 800; // maximum x position
                  const double min = -200; // minimum x position

                  setState(() {
                    _delta = const Offset(100, -150);
                    _position = const Offset(min, 0);
                  });

                  const dxDelta = 20.0;

                  Timer.periodic(const Duration(milliseconds: 60), (timer) {
                    if (_position.dy > 800) {
                      timer.cancel();
                    } else {
                      setState(() {
                        if (_position.dx >= max) {
                          const double deltaY = 90;
                          _position = Offset(min, _position.dy + deltaY);
                        } else {
                          _position = Offset(
                            (_position.dx + dxDelta).clamp(min, max),
                            _position.dy,
                          );
                        }
                      });
                    }
                  });
                },
                child: const Text('Animate'),
              ),
              const SizedBox(height: 8),
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
