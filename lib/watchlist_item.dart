import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistModel {
  static const _watchlistKey = 'watchlist';

  List<WatchlistItem> items = [];

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? watchlistJson = prefs.getStringList(_watchlistKey);
    if (watchlistJson != null) {
      items = watchlistJson.map((json) => WatchlistItem.fromJson(json)).toList();
    }
  }

  Future<void> saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> watchlistJson = items.map((item) => item.toJson()).toList();
    await prefs.setStringList(_watchlistKey, watchlistJson);
  }

  void addToWatchlist(WatchlistItem item) {
    items.add(item);
    saveWatchlist();
  }

  // void removeFromWatchlist(WatchlistItem item) {
  //   items.remove(item);
  //   saveWatchlist();
  // }
}

class WatchlistItem {
  final int movieId;
  final String title;
  final String posterPath;

  WatchlistItem({
    required this.movieId,
    required this.title,
    required this.posterPath,
  });

  factory WatchlistItem.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return WatchlistItem(
      movieId: data['movieId'],
      title: data['title'],
      posterPath: data['posterPath'],
    );
  }

  String toJson() {
    return jsonEncode({
      'movieId': movieId,
      'title': title,
      'posterPath': posterPath,
    });
  }
}
