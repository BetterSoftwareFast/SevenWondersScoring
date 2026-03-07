import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerRoster {
  static const _key = 'player_roster';

  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> save(List<String> names) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, names);
  }

  static Future<void> addNames(List<String> newNames) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    final merged = {...existing, ...newNames}.toList()..sort();
    await prefs.setStringList(_key, merged);
  }
}
