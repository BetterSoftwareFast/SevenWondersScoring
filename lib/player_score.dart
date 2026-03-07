class PlayerScore {
  final String name;

  // Core scoring categories
  int military = 0;
  int coins = 0;
  int wonders = 0;
  int civilian = 0;
  int commerce = 0;
  int guilds = 0;

  // Science categories
  int sciTablets = 0;
  int sciGears = 0;
  int sciCompasses = 0;

  PlayerScore(this.name);

  // Science scoring:
  // tablets² + gears² + compasses² + (min set * 7)
  int get science {
    final t = sciTablets;
    final g = sciGears;
    final c = sciCompasses;

    final base = t * t + g * g + c * c;
    final sets = [t, g, c].reduce((a, b) => a < b ? a : b);

    return base + sets * 7;
  }

  // Total score across all categories
  int get total {
    return military +
        (coins ~/ 3) +
        wonders +
        civilian +
        commerce +
        guilds +
        science;
  }

  // -----------------------------
  // JSON SERIALIZATION
  // -----------------------------

  Map<String, dynamic> toJson() => {
        'name': name,
        'military': military,
        'coins': coins,
        'wonders': wonders,
        'civilian': civilian,
        'commerce': commerce,
        'guilds': guilds,
        'sciTablets': sciTablets,
        'sciGears': sciGears,
        'sciCompasses': sciCompasses,
      };

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    final p = PlayerScore(json['name']);
    p.military = json['military'];
    p.coins = json['coins'];
    p.wonders = json['wonders'];
    p.civilian = json['civilian'];
    p.commerce = json['commerce'];
    p.guilds = json['guilds'];
    p.sciTablets = json['sciTablets'];
    p.sciGears = json['sciGears'];
    p.sciCompasses = json['sciCompasses'];
    return p;
  }
}
