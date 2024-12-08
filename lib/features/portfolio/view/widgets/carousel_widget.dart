import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget(
      {super.key, required this.imageSliders, required this.autoPlay});

  final List<Widget> imageSliders;
  final bool autoPlay;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
            autoPlay: widget.autoPlay,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            // scrollDirection: Axis.vertical
            height: MediaQuery.of(context).size.height - 200),
        items: widget.imageSliders,
      ),
    );
  }
}
