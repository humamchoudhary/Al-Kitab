import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '/main.dart';
import 'package:quran/quran.dart' as quran;

import '../Common/color.dart';

class FirstStart extends StatefulWidget {
  const FirstStart({super.key});

  @override
  State<FirstStart> createState() => _FirstStartState();
}

class _FirstStartState extends State<FirstStart> {
  String? _username = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  double _finalwidth = 0;
  bool loading = false;

  Widget _buildnamefield() {
    return TextFormField(
      style: GoogleFonts.poppins(fontSize: 20, color: HexColor("#BC70FF")),
      decoration: InputDecoration(
          labelText: "Enter your name",
          labelStyle: GoogleFonts.poppins(color: HexColor("#BC70FF")),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BC70FF"))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BC70FF"))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BC70FF")))),
      cursorColor: HexColor("#BC70FF"),
      textAlign: TextAlign.center,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is required';
        }
      },
      onSaved: (String? value) {
        _username = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 450) {
      setState(() {
        _finalwidth = screenWidth - 50;
      });
    } else {
      setState(() {
        _finalwidth = 430;
      });
    }
    ;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(quran.basmala,
                style: TextStyle(
                    fontFamily: "Uthman",
                    fontSize: 40,
                    color: HexColor("#BC70FF"))),
          ),
        ),
        // backgroundColor: HexColor("#BC70FF"),
        body: Stack(children: [
          // Container(
          //     decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //   end: Alignment.center,
          //   begin: Alignment.topLeft,
          //   colors: [
          //     HexColor("#EDA1FF"),
          //     HexColor("#BC70FF"),
          //   ],
          // ))),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome To Al Kitab",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#BC70FF")),
              ),
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                "images/Quran.png",
                width: 250,
                height: 250,
              ),
              Form(
                key: _formkey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: screenWidth - 90,
                        height: 50,
                        child: _buildnamefield())
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#BC70FF"),
                  ),
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      setState(() {
                        FIRSTLOG = false;
                        NAME = _username!;
                      });
                      var userbox = Hive.box("user");
                      userbox.putAll({"name": NAME, "firstlog": FIRSTLOG});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Auth()));
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Submit",
                      style: GoogleFonts.poppins(
                          fontSize: 20, color: Colors.white),
                    ),
                  ))
            ],
          )),
        ]),
      ),
    );
  }
}
