import 'dart:ui';

import 'package:flutflix/api/api.dart';
import 'package:flutflix/models/movieapi.dart';
import 'package:flutflix/models/tvapi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/topRatedslider.dart';
import 'widgets/highestgrossingslider.dart';


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

// menu
class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the menu screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen
                Navigator.pop(context);
              },
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}

// search
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults() async {
    String query = _searchController.text;
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=YOUR_API_KEY&query=$query'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      setState(() {
        _searchResults = jsonBody['results'];
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a movie...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _fetchSearchResults,
            ),
          ),
        ),
      ),
      body: _searchResults.isNotEmpty
          ? ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  title: Text(movie['title']),
                  subtitle: Text(movie['overview']),
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.movie);
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('No results found'),
            ),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> onCinemaMovies;
  late Future<List<TvSeries>> onTVMovies;
  late Future<List<Movie>> childrenFriendly;

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    onCinemaMovies = Api().getOnCinemaMovies();
    onTVMovies = Api().getOnTVMovies();
    childrenFriendly = Api().getChildrenFriendly();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black
            .withOpacity(0.5), // Set the background color to transparent
        elevation: 10,
        title: Image.asset(
          'assets/nflix.png',
          fit: BoxFit.cover,
          height: 50,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
        // menu button
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Navigate to the menu screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          },
        ),
        // search button
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the search screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/image.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Highest-grossing movies',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: FutureBuilder(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return HighestsGrossingSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Top rated this year',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: FutureBuilder(
                      future: topRatedMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TopRatedSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'On at the cinema',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: FutureBuilder(
                      future: onCinemaMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TopRatedSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'On TV tonight',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: FutureBuilder(
                      future: onTVMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TopRatedSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Children-friendly movies',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: FutureBuilder(
                      future: childrenFriendly,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TopRatedSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
