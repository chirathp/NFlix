import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistManager {
  static const _watchlistKey = 'watchlist';

  Future<List<int>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList(_watchlistKey) ?? [];
    return watchlist.map((id) => int.tryParse(id) ?? 0).toList();
  }

  Future<void> addToWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = await getWatchlist();
    if (!watchlist.contains(movieId)) {
      watchlist.add(movieId);
      await prefs.setStringList(_watchlistKey, watchlist.map((id) => id.toString()).toList());
    }
  }

  // Future<void> removeFromWatchlist(int movieId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final watchlist = await getWatchlist();
  //   if (watchlist.contains(movieId)) {
  //     watchlist.remove(movieId);
  //     await prefs.setStringList(_watchlistKey, watchlist.map((id) => id.toString()).toList());
  //   }
  // }
}
