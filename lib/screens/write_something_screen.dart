import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WriteSomethingScreen extends StatefulWidget {
  const WriteSomethingScreen({super.key});

  @override
  State<WriteSomethingScreen> createState() => _WriteSomethingScreenState();
}

class _WriteSomethingScreenState extends State<WriteSomethingScreen> {
  List<Offset> _points = [];
  List<Offset> _undoPoints = [];
  Color _selectedColor = Colors.black;
  final Set<Color> _availableColors = {
    Colors.black,
    Colors.pink,
    Colors.pinkAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.cyan,
    Colors.cyanAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write here'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox object = context.findRenderObject() as RenderBox;
                  Offset localPosition =
                      object.globalToLocal(details.globalPosition);
                  _points = List.from(_points)..add(localPosition);
                });
              },
              // onPanEnd: (details) => _points.clear(),
              child: CustomPaint(
                painter: Signature(_points, _selectedColor),
                size: Size.infinite,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _availableColors
                        .map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = e;
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: e,
                                  border: _selectedColor == e
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        )
                                      : null,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              iconButton(
                icon: CupertinoIcons.arrow_uturn_left_circle,
                tooltip: 'Undo',
                onTap: undo,
              ),
              iconButton(
                icon: CupertinoIcons.arrow_uturn_right_circle,
                tooltip: 'Redo',
                onTap: redo,
              ),
              iconButton(
                icon: CupertinoIcons.clear,
                tooltip: 'Clear',
                onTap: clear,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  iconButton({required IconData icon, VoidCallback? onTap, String? tooltip}) =>
      IconButton.filledTonal(
        tooltip: tooltip ?? 'button',
        onPressed: onTap,
        icon: Icon(icon),
      );

  void undo() => _undoPoints.add(_points.removeLast());

  void redo() => _points.add(_undoPoints.removeLast());

  void clear() => _points.clear();
}

class Signature extends CustomPainter {
  List<Offset> points;
  Color paintColor;

  Signature(this.points, this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = paintColor
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
