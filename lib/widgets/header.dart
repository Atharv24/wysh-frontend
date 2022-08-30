import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
            height: 32,
            child: Text(
              "WYSH",
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      color: blackColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3.15)),
              // style: TextStyle(
              //     color: blackColor, fontSize: 30, fontWeight: FontWeight.w900, fontFamily: GoogleFonts),
            )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: const Text(
              "Keep scrolling to find all the latest trends from 10+ stores",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: subheadingColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16)),
        ),
      ],
    );
  }
}