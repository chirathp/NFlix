import 'dart:ui';

import 'package:flutflix/constants.dart';
import 'package:flutflix/models/tvapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.movie,
  });
  final TvSeries movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Image.asset(
          Image.network(
            '${Constants.imagePath}${movie.backdropPath}',
            //'assets/image.png',
            fit: BoxFit.cover,
            width: double.maxFinite,//800, //double.infinity,
            height: double.maxFinite,//900, //double.infinity,
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
              SliverAppBar.large(
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
                    movie.name,
                    style: GoogleFonts.belleza(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  background: Image.network(
                    '${Constants.imagePath}${movie.backdropPath}',
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
                      Text(
                        'Description',
                        style: GoogleFonts.openSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movie.overView,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
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
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                    movie.firstAirDate,
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
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                    '${movie.voteAverage.toStringAsFixed(1)}/10',
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
