import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ShapesDemoApp());
}

class ShapesDemoApp extends StatelessWidget {
  const ShapesDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shapes Drawing Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ShapesDemoScreen(),
    );
  }
}

class ShapesDemoScreen extends StatefulWidget {
  const ShapesDemoScreen({super.key});

  @override
  State<ShapesDemoScreen> createState() => _ShapesDemoScreenState();
}

class _ShapesDemoScreenState extends State<ShapesDemoScreen> {
  String selectedEmoji = 'Party Face';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emoji App')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown to select an emoji
            DropdownMenu<String>(
              initialSelection: selectedEmoji,
              label: const Text('Select an option'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'Party Face', label: 'Party Face'),
                DropdownMenuEntry(value: 'Heart', label: 'Heart'),
              ],
              onSelected: (String? value) {
                setState(() {
                  selectedEmoji = value!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Painting to draw emoji thats selected
            Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: EmojiPainter(selectedEmoji),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmojiPainter extends CustomPainter {
  final String emojiType;

  EmojiPainter(this.emojiType);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (emojiType == "Party Face") {
      // Base circle face
      final facePaint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, 80, facePaint);

      // Eyes
      final eyePaint = Paint()..color = Colors.black;
      canvas.drawCircle(Offset(center.dx - 30, center.dy - 20), 10, eyePaint);
      canvas.drawCircle(Offset(center.dx + 30, center.dy - 20), 10, eyePaint);

      // Teeth
      final smilePaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 50),
        0.2 * pi,
        0.6 * pi,
        false,
        smilePaint,
      );
      //changes painter to create a heart if heart is selected from the dropdown
    } else if (emojiType == "Heart") {
      final heartPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(center.dx, center.dy + 40);
      path.cubicTo(
        center.dx - 80, center.dy - 20,
        center.dx - 40, center.dy - 100,
        center.dx, center.dy - 40,
      );
      path.cubicTo(
        center.dx + 40, center.dy - 100, 
        center.dx + 80, center.dy - 20,
        center.dx, center.dy + 40, 
      );
      path.close();

      canvas.drawPath(path, heartPaint);
    }
  }
//terminates if the emoji needs to be repainted (if a different emojinis chosen from dropdown)
  @override
  bool shouldRepaint(covariant EmojiPainter oldDelegate) {
    return oldDelegate.emojiType != emojiType;
  }
}
