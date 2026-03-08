import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seven_wonders_scoring/scoring_page.dart';
import 'player_roster.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  final List<TextEditingController> _controllers = [];
  final List<List<String>> suggestions = [];
  List<String> roster = [];

  static const int _maxPlayers = 7;
  static const int _minPlayers = 3;

  @override
  void initState() {
    super.initState();
    _initPlayers();
    _loadRoster();
  }

  void _initPlayers() {
    for (int i = 0; i < _minPlayers; i++) {
      _controllers.add(TextEditingController());
      suggestions.add(<String>[]);
    }
  }

  void _loadRoster() async {
    final playerRoster = await PlayerRoster.load();
    setState(() {
      roster = playerRoster;
      print("ROSTER LOADED: $roster");
    });
  }

  void _addPlayer() {
    if (_controllers.length >= _maxPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 7 players allowed')),
      );
      return;
    }

    setState(() {
      _controllers.add(TextEditingController());
      suggestions.add(<String>[]);
    });
  }

  void _removePlayer(int index) {
    if (_controllers.length <= _minPlayers) return; // enforce minimum 3 players

    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
      suggestions.removeAt(index);
    });
  }

  void _updateSuggestions(int index, String query) {
    if (index < 0 || index >= suggestions.length) return;

    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() => suggestions[index] = []);
      return;
    }

    final lower = query.toLowerCase();

    setState(() {
      suggestions[index] = roster
          .where((name) => name.toLowerCase().contains(lower))
          .toList();
      print("ROSTER LOADED: $roster");
      print("QUERY: '$query' → MATCHES: ${suggestions[index]}");
    });
  }

  void _onContinue() async {
    final names = _controllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (names.length < _minPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter at least $_minPlayers players')),
      );
      return;
    }

    await PlayerRoster.addNames(names);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScoringPage(playerNames: names)),
    );
  }

  bool get _canContinue {
    return _controllers.length >= 3 &&
        _controllers.every((c) => c.text.trim().isNotEmpty);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parchment = const Color(0xFFF8EED9);
    final parchmentDark = const Color(0xFFF3E5C8);
    final gold = const Color(0xFFB8860B);
    final goldBright = const Color(0xFFDAA520);
    final brown = const Color(0xFF4A2F0B);

    final ButtonStyle wondersButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: parchmentDark,
      foregroundColor: brown,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: gold, width: 1.2),
      ),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.25),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("7 Wonders Scoring"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: parchmentDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gold, width: 1.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            goldBright,
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/laurel.svg',
                          ), // or SvgPicture.asset
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: goldBright,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'New Game',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold, color: brown),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add players to begin scoring',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B4E1E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Player list
              Expanded(
                child: ListView.builder(
                  itemCount: _controllers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: parchment,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: gold, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('👤', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _controllers[index],
                                  decoration: const InputDecoration(
                                    hintText: 'Player name',
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: brown, fontSize: 18),
                                  onChanged: (value) =>
                                      _updateSuggestions(index, value),
                                ),
                                if (suggestions[index].isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    decoration: BoxDecoration(
                                      color: parchment,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: gold,
                                        width: 1.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < suggestions[index].length;
                                          i++
                                        ) ...[
                                          InkWell(
                                            onTap: () {
                                              _controllers[index].text =
                                                  suggestions[index][i];
                                              setState(
                                                () => suggestions[index] = [],
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            highlightColor: gold.withOpacity(
                                              0.15,
                                            ),
                                            splashColor: gold.withOpacity(0.25),
                                            child: Container(
                                              color:Colors.white.withValues(alpha: 0.75),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 12,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 18,
                                                    color: brown.withOpacity(
                                                      0.8,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    suggestions[index][i],
                                                    style: TextStyle(
                                                      color: brown,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Divider between items (except last)
                                          if (i < suggestions[index].length - 1)
                                            Divider(
                                              color: gold.withOpacity(0.4),
                                              height: 1,
                                              thickness: 1,
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          if (_controllers.length > _minPlayers)
                            GestureDetector(
                              onTap: () => _removePlayer(index),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '❌',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Add player button
              ElevatedButton.icon(
                style: wondersButtonStyle,
                onPressed: _addPlayer,
                icon: const Text('➕', style: TextStyle(fontSize: 20)),
                label: const Text('Add Player'),
              ),

              const SizedBox(height: 16),

              // Continue button
              ElevatedButton(
                style: wondersButtonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    _canContinue ? goldBright : Colors.grey.shade400,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    _canContinue ? Colors.black : Colors.grey.shade700,
                  ),
                ),
                onPressed: _canContinue ? () => _onContinue() : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
