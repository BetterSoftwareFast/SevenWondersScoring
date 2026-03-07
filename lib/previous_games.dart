import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_score.dart';

class PreviousGame {
  final DateTime date;
  final List<PlayerScore> players;

  PreviousGame({
    required this.date,
    required this.players,
  });

  // A readable label like "2026-03-07 – Adam, Sarah, John"
  String get displayName {
    final dateStr = "${date.year}-${_two(date.month)}-${_two(date.day)}";
    final names = players.map((p) => p.name).join(", ");
    return "$dateStr – $names";
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'players': players.map((p) => p.toJson()).toList(),
      };

  factory PreviousGame.fromJson(Map<String, dynamic> json) {
    return PreviousGame(
      date: DateTime.parse(json['date']),
      players: (json['players'] as List)
          .map((p) => PlayerScore.fromJson(p))
          .toList(),
    );
  }
}

class PreviousGamesStore {
  static const String storageKey = "previous_games";

  // Load all saved games
  static Future<List<PreviousGame>> loadGames() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list.map((g) => PreviousGame.fromJson(g)).toList();
  }

  // Save a new game (append to list)
  static Future<void> saveGame(PreviousGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final games = await loadGames();

    games.add(game);

    final encoded =
        jsonEncode(games.map((g) => g.toJson()).toList());

    await prefs.setString(storageKey, encoded);
  }

  // Delete all saved games
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  // Delete a specific game by index
  static Future<void> deleteGame(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final games = await loadGames();

    if (index < 0 || index >= games.length) return;

    games.removeAt(index);

    final encoded =
        jsonEncode(games.map((g) => g.toJson()).toList());

    await prefs.setString(storageKey, encoded);
  }
}
