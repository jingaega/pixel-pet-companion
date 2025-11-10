import 'package:flutter/material.dart';

class PixelPetSprite extends StatelessWidget {
  final bool sleeping;
  final String mood;
  const PixelPetSprite({super.key, required this.sleeping, required this.mood});

  @override
  Widget build(BuildContext context) {
    const size = 12.0; // pixel block size
    final baseColor = Colors.teal.shade400;
    final dark = Colors.teal.shade800;
    final light = Colors.teal.shade200;

    List<List<Color?>> grid = List.generate(16, (_) => List.filled(16, null));
    void set(int x, int y, Color c) {
      if (x >= 0 && x < 16 && y >= 0 && y < 16) grid[y][x] = c;
    }

    // Body circle-ish
    for (int y = 3; y < 13; y++) {
      for (int x = 3; x < 13; x++) {
        final dx = x - 8;
        final dy = y - 8;
        if (dx*dx + dy*dy <= 22) {
          set(x, y, baseColor);
        }
      }
    }

    // Shading
    for (int y = 4; y < 12; y++) {
      for (int x = 4; x < 12; x++) {
        final dx = x - 8;
        final dy = y - 8;
        if (dx*dx + dy*dy <= 18) set(x, y, light);
      }
    }
    for (int y = 6; y < 14; y++) {
      for (int x = 2; x < 14; x++) {
        final dx = x - 8;
        final dy = y - 8;
        if (dx*dx + dy*dy <= 26 && dy > 1) set(x, y, baseColor.withOpacity(0.9));
        if (dx*dx + dy*dy <= 28 && dy > 2) set(x, y, dark.withOpacity(0.6));
      }
    }

    // Eyes
    if (sleeping) {
      set(6, 8, Colors.black);
      set(7, 8, Colors.black);
      set(10, 8, Colors.black);
      set(9, 8, Colors.black);
    } else {
      set(6, 8, Colors.black);
      set(10, 8, Colors.black);
      set(6, 7, Colors.white);
      set(10, 7, Colors.white);
    }

    // Mouth based on mood
    if (mood == "Ecstatic" || mood == "Happy") {
      set(8, 11, Colors.black);
      set(7, 11, Colors.black);
      set(9, 11, Colors.black);
    } else if (mood == "Okay") {
      set(8, 11, Colors.black);
    } else {
      set(7, 11, Colors.black);
      set(8, 12, Colors.black);
      set(9, 11, Colors.black);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.06),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size * 16,
            height: size * 16,
            child: CustomPaint(painter: _PixelPainter(grid: grid, pixelSize: size)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PixelPainter extends CustomPainter {
  final List<List<Color?>> grid;
  final double pixelSize;
  _PixelPainter({required this.grid, required this.pixelSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        final c = grid[y][x];
        if (c != null) {
          paint.color = c;
          final rect = Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize);
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
