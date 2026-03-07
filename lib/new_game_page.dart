import 'package:flutter/material.dart';
import 'player_roster.dart';

// Simple model
class PlayerEntry {
  String name;
  PlayerEntry({this.name = ''});
}

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  final List<PlayerEntry> players = [
    PlayerEntry(),
    PlayerEntry(),
    PlayerEntry(),
  ];

  List<String> roster = [];

  @override
  void initState() {
    super.initState();
    _loadRoster();
  }

  Future<void> _loadRoster() async {
    final names = await PlayerRoster.load();
    setState(() => roster = names);
  }

 void _addPlayer() {
  if (players.length >= 7) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Maximum of 7 players allowed')),
    );
    return;
  }

  setState(() => players.add(PlayerEntry()));
}

  void _removePlayer(int index) {
    if (players.length > 3) {
      setState(() => players.removeAt(index));
    }
  }

  bool get _canContinue {
    final filled = players.where((p) => p.name.trim().isNotEmpty).length;
    return filled >= 3;
  }

  Widget _autoSuggestField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) return const Iterable<String>.empty();

        return roster.where(
          (name) => name.toLowerCase().contains(query),
        );
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        controller.addListener(() {
          onChanged(controller.text);
          setState(() {});
        });

        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label),
        );
      },
    );
  }

  void _startGame() {
    final names = players
        .map((p) => p.name.trim())
        .where((n) => n.isNotEmpty)
        .toList();

    Navigator.pushNamed(
      context,
      '/scoring',
      arguments: names,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Game')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < players.length; i++)
            Card(
              child: ListTile(
                title: _autoSuggestField(
                  label: 'Player ${i + 1}',
                  initialValue: players[i].name,
                  onChanged: (value) {
                    players[i].name = value;
                  },
                ),
                trailing: players.length > 3
                    ? IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => _removePlayer(i),
                      )
                    : null,
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: players.length < 7 ? _addPlayer : null,
            icon: const Icon(Icons.add),
            label: const Text('Add Player'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _canContinue ? _startGame : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
