class GameResult {
  final String date;
  final List<String> players;
  final Map<String, int> totals;

  GameResult({
    required this.date,
    required this.players,
    required this.totals,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'players': players,
        'totals': totals,
      };
}
