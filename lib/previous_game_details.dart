import 'package:flutter/material.dart';
import 'previous_games.dart';

class PreviousGameDetailsPage extends StatelessWidget {
  final PreviousGame game;

  const PreviousGameDetailsPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final sorted = [...game.players]..sort((a, b) => b.total - a.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              game.displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: sorted.map((p) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _row("Military", p.military),
                          _row("Coins", p.coins ~/ 3),
                          _row("Wonders", p.wonders),
                          _row("Civilian", p.civilian),
                          _row("Commerce", p.commerce),
                          _row("Guilds", p.guilds),
                          _row("Science", p.science),
                          const Divider(),
                          _row("Total", p.total, bold: true),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
