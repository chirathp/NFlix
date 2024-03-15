import 'package:carousel_slider/carousel_slider.dart';
import 'package:nflix/constants.dart';
import 'package:nflix/details/details_movieScreen.dart';
import 'package:nflix/services/auth.dart';
import 'package:flutter/material.dart';

class HighestsGrossingSlider extends StatelessWidget {


  const HighestsGrossingSlider({
    super.key, required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: snapshot.data!.length,
        options: CarouselOptions(
          height: 230,
          autoPlay: true,
          viewportFraction: 0.85,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return GestureDetector(
            onTap:  () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    movie: snapshot.data[itemIndex]
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 300,
                width: 500,
                child: Image.network(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fitHeight,
                  '${Constants.imagePath}${snapshot.data[itemIndex].backdropPath}'
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}