import 'package:flutter/material.dart';
import 'previous_games.dart';
import 'previous_game_details.dart';

class PreviousGamesPage extends StatefulWidget {
  const PreviousGamesPage({super.key});

  @override
  State<PreviousGamesPage> createState() => _PreviousGamesPageState();
}

class _PreviousGamesPageState extends State<PreviousGamesPage> {
  List<PreviousGame> games = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await PreviousGamesStore.loadGames();
    setState(() => games = loaded.reversed.toList()); // newest first
  }

  Future<void> _delete(int index) async {
    await PreviousGamesStore.deleteGame(index);
    await _load();
  }

  void _openDetails(PreviousGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviousGameDetailsPage(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Previous Games")),
      body: games.isEmpty
          ? const Center(
              child: Text(
                "No previous games yet.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (_, i) {
                final g = games[i];
                return Dismissible(
                  key: ValueKey(g.date.toIso8601String()),
                  background: Container(
                    color: Colors.red.shade300,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red.shade300,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _delete(i),
                  child: ListTile(
                    title: Text(g.displayName),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openDetails(g),
                  ),
                );
              },
            ),
    );
  }
}
