import 'dart:ui';

import 'package:nflix/constants.dart';
import 'package:nflix/models/movieapi.dart';
import 'package:nflix/models/tvapi.dart';
import 'package:nflix/watchlist_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final watchlistModel = WatchlistModel();
    
    return Scaffold(
      body: Stack(
        children: [
          //Image.asset(
          Image.network(
            '${Constants.imagePath}${widget.movie.backdropPath}',
            //'assets/image.png',
            fit: BoxFit.cover,
            width: double.maxFinite, //800, //double.infinity,
            height: double.maxFinite, //900, //double.infinity,
          ),
          // to make the image blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 43, 40, 40),
                expandedHeight: 300,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.movie.title,
                    style: GoogleFonts.belleza(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  background: Image.network(
                    '${Constants.imagePath}${widget.movie.backdropPath}',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        widget.movie.overView,
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(
                                    'Release date:  ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.movie.releaseDate,
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(
                                    'Rating:  ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Inside DetailsScreen build method
                          ElevatedButton(
                            onPressed: () {
                              final WatchlistModel watchlistModel = WatchlistModel();
                              watchlistModel.loadWatchlist().then((_) {
                                var movie;
                                watchlistModel.addToWatchlist(WatchlistItem(
                                  movieId: movie.id,
                                  title: movie.title,
                                  posterPath: movie.posterPath,
                                ));
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to watchlist')),
                              );
                            },
                            child: const Text('Add to Watchlist'),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

