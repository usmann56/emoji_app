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
  List<String> selectedOptions = ['arc'];

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
                  // Reset the selected options when emoji changes
                  if (selectedEmoji == 'Party Face') {
                    selectedOptions = ['arc'];
                  } else if (selectedEmoji == 'Heart') {
                    selectedOptions = ['gradient'];
                  }
                });
              },
            ),
            const SizedBox(height: 30),

            // Painting to draw emoji thats selected
            Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: EmojiPainter(selectedEmoji, selectedOptions),
              ),
            ),
            const SizedBox(height: 30),

            // Multi-select checkboxes for sub-options
            const Text('Select variations:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 20,
              children: _getSubOptions().map((option) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: selectedOptions.contains(option.value),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedOptions.add(option.value);
                          } else {
                            selectedOptions.remove(option.value);
                          }
                        });
                      },
                    ),
                    Text(option.label),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuEntry<String>> _getSubOptions() {
    if (selectedEmoji == 'Party Face') {
      return const [
        DropdownMenuEntry(value: 'arc', label: 'Arc'),
        DropdownMenuEntry(value: 'hat', label: 'Hat'),
        DropdownMenuEntry(value: 'confetti', label: 'Confetti'),
      ];
    } else if (selectedEmoji == 'Heart') {
      return const [
        DropdownMenuEntry(value: 'blue color', label: 'Blue Color'),
        DropdownMenuEntry(value: 'broken heart', label: 'Broken Heart'),
        DropdownMenuEntry(value: 'gradient', label: 'Gradient'),
      ];
    }
    return [];
  }
}

class EmojiPainter extends CustomPainter {
  final String emojiType;
  final List<String> selectedOptions;

  EmojiPainter(this.emojiType, this.selectedOptions);

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

      // smile arc
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

      // Handle different party face variations
      if (selectedOptions.contains("arc")) {
        // Small decorative arcs around the face to indicate happy emoji
        final arcColors = [Colors.yellow, Colors.orange, Colors.pink, Colors.lightBlue, Colors.lightGreen];
        
        // Position small arcs around the face - 4 on right, 2 on left, uneven spacing
        final arcPositions = [
          // Left side (2 arcs)
          Offset(center.dx - 55, center.dy - 45), // Top left
          Offset(center.dx - 65, center.dy + 15), // Bottom left
          
          // Right side (4 arcs) - uneven spacing
          Offset(center.dx + 50, center.dy - 70), // Top right
          Offset(center.dx + 75, center.dy - 30), // Upper right
          Offset(center.dx + 60, center.dy + 10), // Middle right
          Offset(center.dx + 80, center.dy + 35), // Lower right
        ];
        
        for (int i = 0; i < arcPositions.length; i++) {
          final smallArcPaint = Paint()
            ..color = arcColors[i % arcColors.length]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;
          
          // Draw small arcs at each position
          canvas.drawArc(
            Rect.fromCenter(center: arcPositions[i], width: 20, height: 20),
            0, // start angle
            pi, // sweep angle (180 degrees for a small arc)
            false,
            smallArcPaint,
          );
        }
      }
      
      if (selectedOptions.contains("hat")) {
        // Party hat - positioned on top of the face
        final hatPaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
        
        // Create a more realistic party hat shape
        final hatPath = Path()
          ..moveTo(center.dx - 25, center.dy - 75)  // Left base of hat
          ..lineTo(center.dx + 25, center.dy - 75)  // Right base of hat
          ..lineTo(center.dx + 20, center.dy - 110) // Right side of hat
          ..lineTo(center.dx - 20, center.dy - 110) // Left side of hat
          ..close();
        canvas.drawPath(hatPath, hatPaint);
        
        // Hat brim
        final brimPaint = Paint()
          ..color = Colors.red.shade700
          ..style = PaintingStyle.fill;
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy - 75),
            width: 60,
            height: 8,
          ),
          brimPaint,
        );
        
        // Hat decorations - colorful stripes
        final stripeColors = [Colors.blue, Colors.yellow, Colors.green];
        for (int i = 0; i < 3; i++) {
          final stripePaint = Paint()
            ..color = stripeColors[i]
            ..style = PaintingStyle.fill;
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(center.dx, center.dy - 85 - (i * 8)),
              width: 40,
              height: 4,
            ),
            stripePaint,
          );
        }
        
        // Pom-pom on top
        final pomPomPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(center.dx, center.dy - 110), 6, pomPomPaint);
      }
      
      if (selectedOptions.contains("confetti")) {
        // Confetti around the face
        final confettiColors = [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.orange];
        for (int i = 0; i < 8; i++) {
          final confettiPaint = Paint()
            ..color = confettiColors[i % confettiColors.length]
            ..style = PaintingStyle.fill;
          
          final angle = i * (pi / 4);
          final radius = 100;
          final x = center.dx + cos(angle) * radius;
          final y = center.dy + sin(angle) * radius;
          
          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: 6, height: 10),
            confettiPaint,
          );
        }
      }
    } else if (emojiType == "Heart") {
      Paint heartPaint;
      
      if (selectedOptions.contains("gradient")) {
        // Create gradient paint - light at top, dark at bottom
        // Use blue gradient if blue color is selected, otherwise red gradient
        final isBlue = selectedOptions.contains("blue color");
        final gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isBlue 
            ? [Colors.lightBlue.shade200, Colors.blue.shade800]
            : [Colors.pink.shade200, Colors.red.shade800],
        );
        heartPaint = Paint()
          ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;
      } else {
        // Solid color paint
        heartPaint = Paint()
          ..color = selectedOptions.contains("blue color") ? Colors.blue : Colors.red
          ..style = PaintingStyle.fill;
      }

      if (selectedOptions.contains("broken heart")) {
        // Draw broken heart with better design - two separate halves with gap
        final gap = 6.0; // Gap between the two halves
        
        // Left half of the heart
        final leftHeartPath = Path();
        leftHeartPath.moveTo(center.dx - gap/2, center.dy + 40);
        leftHeartPath.cubicTo(
          center.dx - 80, center.dy - 20,
          center.dx - 40, center.dy - 100,
          center.dx - 20, center.dy - 40,
        );
        leftHeartPath.cubicTo(
          center.dx - 30, center.dy - 60,
          center.dx - 50, center.dy - 40,
          center.dx - 20, center.dy - 20,
        );
        leftHeartPath.cubicTo(
          center.dx - 25, center.dy - 10,
          center.dx - 35, center.dy - 5,
          center.dx - gap/2, center.dy - 2,
        );
        leftHeartPath.close();
        canvas.drawPath(leftHeartPath, heartPaint);

        // Right half of the heart
        final rightHeartPath = Path();
        rightHeartPath.moveTo(center.dx + gap/2, center.dy + 40);
        rightHeartPath.cubicTo(
          center.dx + 80, center.dy - 20,
          center.dx + 40, center.dy - 100,
          center.dx + 20, center.dy - 40,
        );
        rightHeartPath.cubicTo(
          center.dx + 30, center.dy - 60,
          center.dx + 50, center.dy - 40,
          center.dx + 20, center.dy - 20,
        );
        rightHeartPath.cubicTo(
          center.dx + 25, center.dy - 10,
          center.dx + 35, center.dy - 5,
          center.dx + gap/2, center.dy - 2,
        );
        rightHeartPath.close();
        canvas.drawPath(rightHeartPath, heartPaint);

        // Add jagged crack edges for more realistic broken effect
        final crackPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2;
        
        // Draw jagged crack lines on both sides - improved upper crack design
        final crackPath = Path();
        // Left side jagged edge - more natural crack in upper area
        crackPath.moveTo(center.dx - gap/2, center.dy - 25);
        crackPath.lineTo(center.dx - gap/2 - 1, center.dy - 20);
        crackPath.lineTo(center.dx - gap/2 + 1, center.dy - 15);
        crackPath.lineTo(center.dx - gap/2 - 1, center.dy - 10);
        crackPath.lineTo(center.dx - gap/2 + 1, center.dy - 5);
        crackPath.lineTo(center.dx - gap/2 - 1, center.dy);
        crackPath.lineTo(center.dx - gap/2, center.dy + 3);
        
        // Right side jagged edge - more natural crack in upper area
        crackPath.moveTo(center.dx + gap/2, center.dy - 25);
        crackPath.lineTo(center.dx + gap/2 + 1, center.dy - 20);
        crackPath.lineTo(center.dx + gap/2 - 1, center.dy - 15);
        crackPath.lineTo(center.dx + gap/2 + 1, center.dy - 10);
        crackPath.lineTo(center.dx + gap/2 - 1, center.dy - 5);
        crackPath.lineTo(center.dx + gap/2 + 1, center.dy);
        crackPath.lineTo(center.dx + gap/2, center.dy + 3);
        
        canvas.drawPath(crackPath, crackPaint);
      } else {
        // Normal heart
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
  }
//terminates if the emoji needs to be repainted (if a different emoji or options are chosen)
  @override
  bool shouldRepaint(covariant EmojiPainter oldDelegate) {
    return oldDelegate.emojiType != emojiType || 
           !_listEquals(oldDelegate.selectedOptions, selectedOptions);
  }
  
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
