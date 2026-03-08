import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScoringPage extends StatefulWidget {
  final List<String> playerNames;

  const ScoringPage({super.key, required this.playerNames});

  @override
  State<ScoringPage> createState() => _ScoringPageState();
}

class _ScoringPageState extends State<ScoringPage> {
  final List<String> categories = [
    'Military',
    'Coins',
    'Wonders',
    'Civilian',
    'Commerce',
    'Guilds',
    'Science',
  ];

  late Map<String, List<int>> scores;

  final Map<String, String> categoryIcons = {
    'Military': 'assets/icons/military.svg',
    'Coins': 'assets/icons/coins.svg',
    'Wonders': 'assets/icons/wonders.svg',
    'Civilian': 'assets/icons/civilian.svg',
    'Commerce': 'assets/icons/commerce.svg',
    'Guilds': 'assets/icons/guilds.svg',
    'Science': 'assets/icons/science.svg',
  };

  @override
  void initState() {
    super.initState();
    scores = {
      for (var cat in categories)
        cat: List.filled(widget.playerNames.length, 0),
    };
  }

  int totalForPlayer(int index) {
    return categories.fold(0, (sum, cat) => sum + scores[cat]![index]);
  }

  List<int> get winners {
    final totals = List.generate(widget.playerNames.length, totalForPlayer);
    final maxScore = totals.reduce((a, b) => a > b ? a : b);
    return List.generate(
      totals.length,
      (i) => i,
    ).where((i) => totals[i] == maxScore).toList();
  }

  @override
  Widget build(BuildContext context) {
    const parchment = Color(0xFFF8EED9);
    const parchmentDark = Color(0xFFF3E5C8);
    const gold = Color(0xFFB8860B);
    const goldBright = Color(0xFFDAA520);
    const brown = Color(0xFF4A2F0B);

    final ButtonStyle wondersButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: goldBright,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: gold, width: 1.2),
      ),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.25),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(
        title: null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
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
                          colorFilter: const ColorFilter.mode(
                            goldBright,
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset('assets/icons/laurel.svg'),
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
                      'Scoring',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold, color: brown),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter scores for each category',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF6B4E1E),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable scoring grid
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Player name header row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const SizedBox(width: 120), // icon + label column
                        for (int i = 0; i < widget.playerNames.length; i++)
                          Expanded(
                            child: Text(
                              widget.playerNames[i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: brown,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Category rows
                  for (var cat in categories)
                    _buildCategoryRow(
                      label: cat,
                      iconPath: categoryIcons[cat]!,
                      parchment: parchment,
                      gold: gold,
                      brown: brown,
                      onChanged: (playerIndex, value) {
                        setState(() {
                          scores[cat]![playerIndex] = value;
                        });
                      },
                    ),

                  const SizedBox(height: 12),

                  // Total row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: goldBright.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: goldBright, width: 1.4),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text(
                            'Total',
                            style: TextStyle(
                              color: brown,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        for (int i = 0; i < widget.playerNames.length; i++)
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: winners.contains(i)
                                    ? goldBright.withOpacity(0.4)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                totalForPlayer(i).toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: winners.contains(i)
                                      ? Colors.black
                                      : brown,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action bar
            // Bottom action area
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              color: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: wondersButtonStyle,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/results',
                      arguments: {
                        'players': widget.playerNames,
                        'scores': scores,
                      },
                    );
                  },
                  child: const Text('Finish Scoring'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Map<String, Color> categoryColors = {
    'Military': const Color(0xFFFFE5E5),
    'Coins': const Color(0xFFFFF6D5),
    'Wonders': const Color(0xFFEDE7E3),
    'Civilian': const Color(0xFFE3F0FF),
    'Commerce': const Color(0xFFFFEDD8),
    'Guilds': const Color(0xFFEDE3FF),
    'Science': const Color(0xFFE6F7E6),
  };

  Widget _buildCategoryRow({
    required String label,
    required String iconPath,
    required Color parchment,
    required Color gold,
    required Color brown,
    required Function(int playerIndex, int value) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: categoryColors[label] ?? parchment, // ← NEW
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
          SizedBox(
            width: 120,
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    categoryColors[label]!
                        .withOpacity(0.9)
                        .withRed(120)
                        .withGreen(90)
                        .withBlue(40),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: brown,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Score inputs
          for (int i = 0; i < widget.playerNames.length; i++)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value) ?? 0;
                    onChanged(i, parsed);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
