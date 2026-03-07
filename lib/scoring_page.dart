import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'player_score.dart';
import 'player_roster.dart';
import 'previous_games.dart';

class ScoringPage extends StatefulWidget {
  final List<String> playerNames;

  const ScoringPage({super.key, required this.playerNames});

  @override
  State<ScoringPage> createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPage> {
  late List<PlayerScore> scores;
  List<int> winnerIndices = [];

  @override
  void initState() {
    super.initState();
    scores = widget.playerNames.map((n) => PlayerScore(n)).toList();
    _updateWinners();
  }

  // ------------------------------------------------------------
  // ICON + LABEL HELPERS
  // ------------------------------------------------------------

  Widget scoreIcon(String assetName, {Color? color}) {
    return SvgPicture.asset(
      'assets/icons/$assetName',
      width: 22,
      height: 22,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  Widget label(String text, String iconAsset, Color color) {
    return Row(
      children: [
        scoreIcon(iconAsset, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: color,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CELL + ROW HELPERS
  // ------------------------------------------------------------

  Widget cell({required int value, required void Function(int) onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: SizedBox(
        width: 65,
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          controller: TextEditingController(text: value.toString())
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.toString().length),
            ),
          onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
        ),
      ),
    );
  }

  Widget highlightableCell({
    required int value,
    required void Function(int) onChanged,
    required bool highlight,
  }) {
    return Container(
      decoration: highlight
          ? BoxDecoration(
              color: Colors.amber.shade200.withOpacity(0.35),
              border: Border(
                left: BorderSide(color: Colors.amber.shade700, width: 2),
                right: BorderSide(color: Colors.amber.shade700, width: 2),
              ),
            )
          : null,
      child: cell(value: value, onChanged: onChanged),
    );
  }

  TableRow row(Widget label, List<Widget> cells, {BoxDecoration? decoration}) {
    return TableRow(
      decoration:
          decoration ??
          const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: label,
        ),
        ...cells,
      ],
    );
  }

  // ------------------------------------------------------------
  // WINNER LOGIC
  // ------------------------------------------------------------

  int clampScore(int value, String category) {
    switch (category) {
      case 'military':
        return value.clamp(-6, 18);
      case 'coins':
        return value < 0 ? 0 : value;
      case 'wonders':
        return value.clamp(0, 20);
      case 'civilian':
        return value.clamp(0, 30);
      case 'commerce':
        return value.clamp(0, 20);
      case 'guilds':
        return value.clamp(0, 20);
      case 'sciTablets':
      case 'sciGears':
      case 'sciCompasses':
        return value.clamp(0, 10);
      default:
        return value;
    }
  }

  void _updateWinners() {
    final totals = scores.map((p) => p.total).toList();
    final maxScore = totals.reduce((a, b) => a > b ? a : b);

    winnerIndices = [];
    for (int i = 0; i < totals.length; i++) {
      if (totals[i] == maxScore) {
        winnerIndices.add(i);
      }
    }
  }

  // ------------------------------------------------------------
  // HEADER WITH CROWN
  // ------------------------------------------------------------

  Widget headerCell(String name, bool isWinner) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isWinner)
            Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 22),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FINISH GAME
  // ------------------------------------------------------------
  void _finishGame() async {
    // Save player names to roster
    await PlayerRoster.addNames(scores.map((s) => s.name).toList());

    // SAVE THE GAME HERE
    await PreviousGamesStore.saveGame(
      PreviousGame(
        date: DateTime.now(),
        players: scores.map((p) => PlayerScore.fromJson(p.toJson())).toList(),
      ),
    );

    // Sort for display
    final sorted = [...scores]..sort((a, b) => b.total - a.total);

    // Show results dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sorted
              .map(
                (p) => ListTile(
                  title: Text(p.name),
                  trailing: Text(
                    p.total.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/')),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scoring')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: TableBorder.symmetric(
              inside: const BorderSide(color: Colors.black12),
              outside: const BorderSide(color: Colors.black),
            ),
            children: [
              // HEADER ROW
              TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black)),
                ),
                children: [
                  const SizedBox(),
                  for (int i = 0; i < scores.length; i++)
                    headerCell(scores[i].name, winnerIndices.contains(i)),
                ],
              ),

              // CATEGORY ROWS
              row(label('Military', 'military.svg', Colors.red.shade700), [
                for (int i = 0; i < scores.length; i++)
                  highlightableCell(
                    value: scores[i].military,
                    onChanged: (v) => setState(() {
                      scores[i].military = clampScore(v, 'military');;
                      _updateWinners();
                    }),
                    highlight: winnerIndices.contains(i),
                  ),
              ]),

              row(label('Coins', 'coins.svg', Colors.amber.shade700), [
                for (int i = 0; i < scores.length; i++)
                  highlightableCell(
                    value: scores[i].coins,
                    onChanged: (v) => setState(() {
                      scores[i].coins = clampScore(v, 'coins');;
                      _updateWinners();
                    }),
                    highlight: winnerIndices.contains(i),
                  ),
              ]),

              row(label('Wonders', 'wonders.svg', Colors.brown.shade600), [
                for (int i = 0; i < scores.length; i++)
                  highlightableCell(
                    value: scores[i].wonders,
                    onChanged: (v) => setState(() {
                      scores[i].wonders = clampScore(v, 'wonders');;
                      _updateWinners();
                    }),
                    highlight: winnerIndices.contains(i),
                  ),
              ]),

              row(label('Civilian', 'civilian.svg', Colors.blue.shade600), [
                for (int i = 0; i < scores.length; i++)
                  highlightableCell(
                    value: scores[i].civilian,
                    onChanged: (v) => setState(() {
                      scores[i].civilian = clampScore(v, 'civilian');;
                      _updateWinners();
                    }),
                    highlight: winnerIndices.contains(i),
                  ),
              ]),

              row(label('Commerce', 'commerce.svg', Colors.amber.shade600), [
                for (int i = 0; i < scores.length; i++)
                  highlightableCell(
                    value: scores[i].commerce,
                    onChanged: (v) => setState(() {
                      scores[i].commerce = clampScore(v, 'commerce');;
                      _updateWinners();
                    }),
                    highlight: winnerIndices.contains(i),
                  ),
              ]),

              row(label('Guilds', 'guilds.svg', Colors.purple.shade600), [
                for (int i = 0; i < scores.length; i++)
                  highlightableCell(
                    value: scores[i].guilds,
                    onChanged: (v) => setState(() {
                      scores[i].guilds = clampScore(v, 'guilds');;
                      _updateWinners();
                    }),
                    highlight: winnerIndices.contains(i),
                  ),
              ]),

              // SCIENCE
              row(
                label(
                  'Sci: Tablets',
                  'science_tablet.svg',
                  Colors.green.shade700,
                ),
                [
                  for (int i = 0; i < scores.length; i++)
                    highlightableCell(
                      value: scores[i].sciTablets,
                      onChanged: (v) => setState(() {
                        scores[i].sciTablets = clampScore(v, 'sciTablets');
                        _updateWinners();
                      }),
                      highlight: winnerIndices.contains(i),
                    ),
                ],
              ),

              row(
                label('Sci: Gears', 'science_gear.svg', Colors.green.shade700),
                [
                  for (int i = 0; i < scores.length; i++)
                    highlightableCell(
                      value: scores[i].sciGears,
                      onChanged: (v) => setState(() {
                        scores[i].sciGears = clampScore(v, 'sciGears');;
                        _updateWinners();
                      }),
                      highlight: winnerIndices.contains(i),
                    ),
                ],
              ),

              row(
                label(
                  'Sci: Compasses',
                  'science_compass.svg',
                  Colors.green.shade700,
                ),
                [
                  for (int i = 0; i < scores.length; i++)
                    highlightableCell(
                      value: scores[i].sciCompasses,
                      onChanged: (v) => setState(() {
                        scores[i].sciCompasses = clampScore(v, 'sciCompases');;
                        _updateWinners();
                      }),
                      highlight: winnerIndices.contains(i),
                    ),
                ],
              ),

              // SCIENCE TOTAL
              row(
                label(
                  'Science Total',
                  'science_total.svg',
                  Colors.green.shade700,
                ),
                [
                  for (int i = 0; i < scores.length; i++)
                    Container(
                      decoration: winnerIndices.contains(i)
                          ? BoxDecoration(
                              color: Colors.green.shade700.withOpacity(0.08),
                              border: Border(
                                left: BorderSide(
                                  color: Colors.amber.shade700,
                                  width: 2,
                                ),
                                right: BorderSide(
                                  color: Colors.amber.shade700,
                                  width: 2,
                                ),
                              ),
                            )
                          : null,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        scores[i].science.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),

              // TOTAL
              row(label('Total', 'total.svg', Colors.amber.shade800), [
                for (int i = 0; i < scores.length; i++)
                  Container(
                    decoration: winnerIndices.contains(i)
                        ? BoxDecoration(
                            color: Colors.amber.shade200.withOpacity(0.35),
                            border: Border(
                              left: BorderSide(
                                color: Colors.amber.shade700,
                                width: 2,
                              ),
                              right: BorderSide(
                                color: Colors.amber.shade700,
                                width: 2,
                              ),
                            ),
                          )
                        : null,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      scores[i].total.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: _finishGame,
          icon: const Icon(Icons.leaderboard),
          label: const Text('Finish Game'),
        ),
      ),
    );
  }
}
