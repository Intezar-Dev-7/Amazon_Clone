import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/utils/constants/image_strings.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items:
          carouselImages.map((i) {
            return Builder(
              builder:
                  (BuildContext context) =>
                      Image.network(i, fit: BoxFit.cover, height: 200),
            );
          }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1,
        height: 200,
      ),
    );
  }
}
