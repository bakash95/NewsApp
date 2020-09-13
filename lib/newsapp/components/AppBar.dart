import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Color(0xfffe4066),
    elevation : 0,
    title: Center(
        child: Text(
          'News App',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold
            ),
            color: Colors.white,
          ),
        )),
  );
}