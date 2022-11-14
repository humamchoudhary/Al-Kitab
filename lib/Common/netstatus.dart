import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quran_app/Common/color.dart';
import 'package:quran_app/main.dart';

class NetStatus extends StatefulWidget {
  const NetStatus({Key? key}) : super(key: key);

  @override
  State<NetStatus> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  getNet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    setState(() {
      ISNETON = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGCOLOR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber,color: Colors.amber,size: 40,),
            SizedBox(height: 10,),
            Text(
              "App requires InterNet",
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: TEXTCOLOR,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor("#BC70FF"),
              ),
              onPressed: () {
                getNet();
              },
              child: Text(
                "Check Network status",
                textAlign: TextAlign.end,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );;
  }
}
