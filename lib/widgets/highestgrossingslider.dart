import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutflix/constants.dart';
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