import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResultsPage extends StatefulWidget {
  final List<String> players;
  final Map<String, List<int>> scores;

  const ResultsPage({
    super.key,
    required this.players,
    required this.scores,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int totalForPlayer(int index) {
    return widget.scores.values.fold(0, (sum, list) => sum + list[index]);
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors
    const parchment = Color(0xFFF8EED9);
    const parchmentDark = Color(0xFFF3E5C8);
    const gold = Color(0xFFB8860B);
    const goldBright = Color(0xFFDAA520);
    const brown = Color(0xFF4A2F0B);

    // Category colors
    final Map<String, Color> categoryColors = {
      'Military': const Color(0xFFFFE5E5),
      'Coins': const Color(0xFFFFF6D5),
      'Wonders': const Color(0xFFEDE7E3),
      'Civilian': const Color(0xFFE3F0FF),
      'Commerce': const Color(0xFFFFEDD8),
      'Guilds': const Color(0xFFEDE3FF),
      'Science': const Color(0xFFE6F7E6),
    };

    // Category icons
    final Map<String, String> categoryIcons = {
      'Military': 'assets/icons/military.svg',
      'Coins': 'assets/icons/coins.svg',
      'Wonders': 'assets/icons/wonders.svg',
      'Civilian': 'assets/icons/civilian.svg',
      'Commerce': 'assets/icons/commerce.svg',
      'Guilds': 'assets/icons/guilds.svg',
      'Science': 'assets/icons/science.svg',
    };

    // Totals + winners
    final totals = List.generate(widget.players.length, totalForPlayer);
    final maxScore = totals.reduce((a, b) => a > b ? a : b);
    final winners = List.generate(widget.players.length, (i) => i)
        .where((i) => totals[i] == maxScore)
        .toList();

    // Buttons
    final ButtonStyle primaryButton = ElevatedButton.styleFrom(
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

    final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
      backgroundColor: parchmentDark,
      foregroundColor: brown,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: gold, width: 1.2),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.15),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Winner banner
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                  children: [
                    // SHIMMERED LAUREL ICON
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment(-1.0 + _controller.value * 2, 0),
                              end: Alignment(1.0 + _controller.value * 2, 0),
                              colors: [
                                Colors.transparent,
                                goldBright.withOpacity(0.9),
                                Colors.transparent,
                              ],
                              stops: const [0.35, 0.5, 0.65],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.srcATop,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: SvgPicture.asset(
                          'assets/icons/laurel.svg',
                          colorFilter: const ColorFilter.mode(goldBright, BlendMode.srcIn),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Static label
                    Text(
                      winners.length == 1 ? 'Winner' : 'Winners',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: brown,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // SHIMMERED WINNER NAME
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment(-1.0 + _controller.value * 2, 0),
                              end: Alignment(1.0 + _controller.value * 2, 0),
                              colors: [
                                Colors.transparent,
                                goldBright.withOpacity(0.9),
                                Colors.transparent,
                              ],
                              stops: const [0.35, 0.5, 0.65],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.srcATop,
                          child: child,
                        );
                      },
                      child: Text(
                        winners.map((i) => widget.players[i]).join(', '),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: goldBright,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Results card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: ListView(
                    children: [
                      // Player totals
                      for (int i = 0; i < widget.players.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: winners.contains(i)
                                ? goldBright.withOpacity(0.35)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    widget.players[i],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: brown,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                totals[i].toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: winners.contains(i) ? Colors.black : brown,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      Text(
                        'Category Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: brown,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Category rows
                      for (var cat in widget.scores.keys)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: categoryColors[cat] ?? parchmentDark,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: gold, width: 1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: SvgPicture.asset(
                                  categoryIcons[cat]!,
                                  colorFilter: const ColorFilter.mode(brown, BlendMode.srcIn),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: brown,
                                    ),
                                  ),
                                ),
                              ),
                              for (int i = 0; i < widget.players.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    widget.scores[cat]![i].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: brown,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: secondaryButton,
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: const Text('Home'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: primaryButton,
                      onPressed: () {
                        Navigator.pushNamed(context, '/new_game');
                      },
                      child: const Text('New Game'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
