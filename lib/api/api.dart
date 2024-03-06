import 'dart:convert';

import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movieapi.dart';
import 'package:flutflix/models/tvapi.dart';
import 'package:http/http.dart' as http;

class Api {
  static const trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const onCinemaUrl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';
  static const onTVUrl =
      'https://api.themoviedb.org/3/tv/airing_today?api_key=${Constants.apiKey}';
  static const childrenFriendlyUrl =
      'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&sort_by=revenue.desc&adult=false&with_genres=16 - children friendly';
  // static const searchUrl =
  //     'https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}';

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getOnCinemaMovies() async {
    final response = await http.get(Uri.parse(onCinemaUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<TvSeries>> getOnTVMovies() async {
    final response = await http.get(Uri.parse(onTVUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => TvSeries.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getChildrenFriendly() async {
    final response = await http.get(Uri.parse(childrenFriendlyUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }  
}

Future<List<Movie>> searchMovies(String query) async {
  final url = 'https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&query=$query';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body)['results'] as List;
    return decodedData.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    throw Exception('Failed to load search results');
  }
}

Future<List<Movie>> searchTvShows(String query) async {
  final url = 'https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&query=$query';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body)['results'] as List;
    return decodedData.map((tvShow) => Movie.fromJson(tvShow)).toList();
  } else {
    throw Exception('Failed to load search results');
  }
}



