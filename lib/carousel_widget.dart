import 'dart:io';
import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio_site/RadialGradientColorSplash.dart';
import 'package:portfolio_site/resume_pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:pdfx/pdfx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatefulWidget {
  CarouselSliderController controller = CarouselSliderController();
  bool isPaused = false;
  int currentImageIndex = 0;
  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarouselSlider(
              carouselController: widget.controller,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    widget.currentImageIndex = index;
                  });
                },
                height: 500.0,
                aspectRatio: 16/9,
                viewportFraction: 0.8,
                initialPage: widget.currentImageIndex,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,

              ), items: [
                LabeledCarouselitem(Image.asset('sexydude;).png'), 'Me in a nice snowy field'),
                LabeledCarouselitem(Image.asset('assets/ukg.png'), 'My first internship, at UKG. Worked on the Kafka team, and learned a lot!'),
                LabeledCarouselitem(Image.asset('assets/luncheon.jpg'), 'Exit lunch with other interns at Persistent Systems, LLC. Working with these people was a lot of fun!'),
                LabeledCarouselitem(Image.asset('assets/radio.jpg'), 'One of the radios I worked on during my time at Persistent'),
                LabeledCarouselitem(Image.asset('assets/wiring_diagram.png'), 'Wonky little wiring diagram I made for the power switch test board for RIT\'s Electric Vehicle team'),
            ],
            ),
          ),
        ),
        // pause button (returns a null for some reason?)
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         setState(() {
        //           widget.isPaused = !widget.isPaused;
        //           if (widget.isPaused) {
        //             widget.controller.stopAutoPlay();
        //           } else {
        //             widget.controller.startAutoPlay();
        //           }
        //         });
        //       },
        //       child: Row(
        //         children: [
        //           Text(widget.isPaused ? 'Resume' : 'Pause'),
        //           const SizedBox(width: 10),
        //           Icon(widget.isPaused ? Icons.play_arrow : Icons.pause),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class LabeledCarouselitem extends StatelessWidget {
  final Image image;
  final String description;
  LabeledCarouselitem(this.image, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.secondary;
    return Container(
      child: Column(
        children: [
          Flexible(
              flex: 4,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                      color: backgroundColor,
                      child: image)
              )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}