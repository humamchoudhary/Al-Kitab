import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/Pages/SettingsPage.dart';
import 'package:quran_app/Pages/howtouse.dart';
import 'package:quran_app/main.dart';

import 'color.dart';

class NavDrawer extends StatefulWidget {
  final String title;
  const NavDrawer({super.key, required this.title});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final GlobalKey<ScaffoldState> drawkey = GlobalKey();

  // List drawitem = ["Home", "Settings", "How to Use", "About", "Donation"];
  List drawitem = ["Home", "Settings", "About", "Donation"];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: BGCOLOR,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 30),
        child: Column(
          children: [
            Container(
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#BC70FF")),
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: itemBuilder,
                separatorBuilder: separatorBuilder,
                itemCount: drawitem.length),
          ],
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          if (index == 0) {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Auth()));
          } else if (index == 1) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          }
          // else if (index == 2) {
          //   Navigator.pop(context);
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => HowToUse()));
          // }
        },
        child: ListTile(
          title: Text(
            drawitem[index],
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w300, color: TEXTCOLOR),
          ),
        ),
      ),
    );
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return Divider(
      color: TEXTCOLOR,
    );
  }
}
