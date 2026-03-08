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

  @override
  void initState() {
    super.initState();
    // Start with 3 default players
    for (int i = 0; i < 3; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _addPlayer() {
    if (_controllers.length >= 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 7 players allowed')),
      );
      return;
    }

    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removePlayer(int index) {
    if (_controllers.length <= 3) return; // enforce minimum 3 players
    setState(() {
      _controllers.removeAt(index);
    });
  }

  void _goToScoring() async {
    final newNames = _controllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    PlayerRoster.addNames(newNames);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoringPage(playerNames: newNames),
      ),
    );
  }

  bool get _canContinue {
    return _controllers.length >= 3 &&
        _controllers.every((c) => c.text.trim().isNotEmpty);
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
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('👤', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _controllers[index],
                              decoration: const InputDecoration(
                                hintText: 'Player name',
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: brown, fontSize: 18),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          if (_controllers.length > 3)
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
                onPressed: _canContinue
                    ? () => _goToScoring()
                    : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
