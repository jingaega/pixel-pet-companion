import 'package:flutter/material.dart';

class Gauge extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const Gauge({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cs.primaryContainer.withOpacity(0.4),
          border: Border.all(color: cs.primary.withOpacity(0.4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)]),
            const SizedBox(height: 6),
            SizedBox(
              height: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: value / 100.0),
              ),
            ),
            const SizedBox(height: 4),
            Text("$value/100", style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
