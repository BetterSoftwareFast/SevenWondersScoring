import 'package:flutter/material.dart';
import 'package:seven_wonders_scoring/results_page.dart';
import 'package:seven_wonders_scoring/scoring_page.dart';
import 'home_page.dart';
import 'new_game_page.dart';
import 'previous_games_page.dart';

void main() {
  runApp(const SevenWondersApp());
}

class SevenWondersApp extends StatelessWidget {
  const SevenWondersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7 Wonders Scoring',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/new_game': (context) => const NewGamePage(),
        '/scoring': (context) {
          final names =
              ModalRoute.of(context)!.settings.arguments as List<String>;
          return ScoringPage(playerNames: names);
        },
        '/previous-games': (context) => const PreviousGamesPage(),
        '/results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ResultsPage(
              players: args['players'],
              scores: args['scores'],
            );
        },
      }
    );
  }
}
