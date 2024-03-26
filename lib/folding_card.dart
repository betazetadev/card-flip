import 'package:flutter/material.dart';
import 'dart:math' as math;

class FoldingCard extends StatefulWidget {
  @override
  _FoldingCardState createState() => _FoldingCardState();
}

class _FoldingCardState extends State<FoldingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Calculate the delta to adjust the rotation
        final screenWidth = MediaQuery.of(context).size.width;
        final percentage = 4 * details.primaryDelta! / screenWidth;
        _controller.value += percentage;
      },
      onHorizontalDragEnd: (details) {
        if (_controller.value > 0.5)
          _controller.forward();
        else
          _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final isFront = _controller.value < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY((isFront ? _controller.value : 1 - _controller.value) *
                  math.pi),
            child: ClipRect(
              child: isFront ? FrontCard() : BackCard(),
            ),
          );
        },
      ),
    );
  }
}

class FrontCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 5,
      child: Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: Text('Front Card',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}

class BackCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 5,
      child: Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: Text('Back Card',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
