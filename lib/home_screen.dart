import 'dart:ui';

import 'package:flutflix/api/api.dart';
import 'package:flutflix/models/movieapi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/topRatedslider.dart';
import 'widgets/highestgrossingslider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Search for movies here'),
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

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> onCinemaMovies;
  late Future<List<Movie>> onTVMovies;

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    onCinemaMovies = Api().getOnCinemaMovies();
    onTVMovies = Api().getOnTVMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5), // Set the background color to transparent
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
          icon: Icon(Icons.menu),
          onPressed: () {
            // handling the menu button tap
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
                MaterialPageRoute(builder: (context) => SearchScreen()),
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
                        if(snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if(snapshot.hasData) {
                          return HighestsGrossingSlider(snapshot: snapshot,);
                        } else{
                          return const Center(child: CircularProgressIndicator());
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
                        if(snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if(snapshot.hasData) {
                          return TopRatedSlider(snapshot: snapshot,);
                        } else{
                          return const Center(child: CircularProgressIndicator());
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
                        if(snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if(snapshot.hasData) {
                          return TopRatedSlider(snapshot: snapshot,);
                        } else{
                          return const Center(child: CircularProgressIndicator());
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
                        if(snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if(snapshot.hasData) {
                          return TopRatedSlider(snapshot: snapshot,);
                        } else{
                          return const Center(child: CircularProgressIndicator());
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
                      future: topRatedMovies, // PUT THIS CORRECTLY
                      builder: (context, snapshot) {
                        if(snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if(snapshot.hasData) {
                          return TopRatedSlider(snapshot: snapshot,);
                        } else{
                          return const Center(child: CircularProgressIndicator());
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



