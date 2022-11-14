import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Common/color.dart';
import '../Common/navdrawer.dart';
import '../main.dart';

class HowToUse extends StatelessWidget {
  const HowToUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(
        title: "Al Kitab",
      ),
      backgroundColor: BGCOLOR,
      appBar: AppBar(
        iconTheme: IconThemeData(color: TEXTCOLOR),
        elevation: 0,
        title: Text(
          "How To Use",
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor("#BC70FF")),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const Auth()));
              },
              icon: Icon(
                Icons.home,
                color: TEXTCOLOR,
              ))
        ],
        backgroundColor: BGCOLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(children: [
          Center(
            child: Text(
              "An Easy Guide of the App",
              style:
                  GoogleFonts.poppins(fontSize: 25, color: HexColor("#BC70FF")),
            ),
          ),
          const SizedBox(height: 20,),
          ListTile(
            leading: Image.asset(
              "images/double-tap.png",
              width: 35,
              height: 35,
            ),
            title: Text(
              "Double tap ayah",
              style:
                  GoogleFonts.poppins(fontSize: 18, color: HexColor("#BC70FF")),
            ),
            subtitle: Text(
              "To set the ayah as last seen",
              style:
                  GoogleFonts.poppins(fontSize: 15, color: HexColor("#BC70FF")),
            ),
          ),
        ]),
      ),
    );
  }
}
