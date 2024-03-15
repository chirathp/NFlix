import 'dart:ui';

import 'package:nflix/api/api.dart';
import 'package:nflix/constants.dart';
import 'package:nflix/details/details_movieScreen.dart';
import 'package:nflix/models/movieapi.dart';
import 'package:nflix/models/tvapi.dart';
import 'package:nflix/watchlist_item.dart';
import 'package:nflix/widgets/tv_topRatedslider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/topRatedslider.dart';
import 'widgets/highestgrossingslider.dart';

//packages imported when search bar implemented
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}


class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late WatchlistModel watchlistModel;
  late Api api;

  @override
  void initState() {
    super.initState();
    watchlistModel = WatchlistModel();
    api = Api();
    watchlistModel.loadWatchlist().then((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: FutureBuilder(
        future: _loadMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (watchlistModel.items.isEmpty) {
              return const Center(child: Text('No movies in watchlist'));
            } else {
              return ListView.builder(
                itemCount: watchlistModel.items.length,
                itemBuilder: (context, index) {
                  final item = watchlistModel.items[index];
                  return ListTile(
                    title: Text(item.title),
                    leading: Image.network(item.posterPath),
                    onTap: () {
                      // Implement navigation to movie details screen here
                    },
                  );
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<Movie>> _loadMovies() async {
    final List<Movie> movies = [];
    for (final item in watchlistModel.items) {
      final movie = await api.getMovieDetails(item.movieId);
      movies.add(movie);
    }
    return movies;
  }
}



// menu
class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WatchlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/background_image.jpg', // Replace with your background image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Transparent overlay
          Container(
            color:
                Colors.black.withOpacity(0.5), // Adjust the opacity as needed
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          
        ],
      ),
    );
  }
}

// search
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/person?api_key=${Constants.apiKey}&query=$query'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final personId = jsonBody['results'][0]
          ['id']; // Assuming the first result is the desired person
      final moviesResponse = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/person/$personId/movie_credits?api_key=${Constants.apiKey}'));

      if (moviesResponse.statusCode == 200) {
        final moviesJsonBody = json.decode(moviesResponse.body);
        setState(() {
          _isLoading = false;
          _searchResults = moviesJsonBody['cast'];
        });
      } else {
        setState(() {
          _isLoading = false;
          _searchResults = [];
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSearchResults(text);
    });
  }

  void _navigateToDetailsScreen(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          movie: Movie.fromJson(movie),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchTextChanged,
          decoration: const InputDecoration(
            hintText: 'Search for a movie...',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isNotEmpty
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
                      onTap: () => _navigateToDetailsScreen(movie),
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
                          return TVTopRatedSlider(
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
