// ignore_for_file: unused_import, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstore/localstore.dart';
import 'package:quran_app/main.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Common/color.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final local = Localstore.instance;

  String? _username;

  bool _textenable = false;

  TextEditingController namecontrol = TextEditingController();

  String? errortext;

  double textwidth = 250;

  savePref() {
    var setbox = Hive.box("settings");
    setbox.putAll({"darkmode": DARKMODE, "translation": TRANSLATION});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      namecontrol.text = NAME;
    });
  }

  Widget _buildnamefield() {
    return TextField(
      enabled: _textenable,
      controller: namecontrol,
      style: GoogleFonts.poppins(
          fontSize: 20,
          color: _textenable ? HexColor("#BC70FF") : HexColor("#808080")),
      decoration: InputDecoration(
          labelText: "Enter your name",
          labelStyle: GoogleFonts.poppins(
            color: _textenable ? HexColor("#BC70FF") : HexColor("#808080"),
          ),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BC70FF"), width: 0.5)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BC70FF"), width: 0.5))),
      cursorColor: HexColor("#BC70FF"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGCOLOR,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: TEXTCOLOR,
        ),
        elevation: 0,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor("#BC70FF")),
        ),
        backgroundColor: BGCOLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Settings",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: HexColor("#BC70FF")),
            ),
            Divider(color: HexColor("#BC70FF")),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Night Mode",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: HexColor("#BC70FF")),
                    ),
                    Text(
                      DARKMODE ? "Night" : "Light",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: HexColor("#BC70FF")),
                    ),
                  ],
                ),
                Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: DARKMODE,
                      onChanged: _modeswitch,
                      activeColor: HexColor("#BC70FF"),
                    ))
              ],
            ),
            const Divider(
              color: Color.fromARGB(90, 188, 112, 255),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Translation",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: HexColor("#BC70FF")),
                    ),
                    Text(
                      TRANSLATION ? "Enabled" : "Disabled",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: HexColor("#BC70FF")),
                    ),
                  ],
                ),
                Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: TRANSLATION,
                      onChanged: _tranlationswitch,
                      activeColor: HexColor("#BC70FF"),
                    ))
              ],
            ),
            const Divider(
              color: Color.fromARGB(90, 188, 112, 255),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: _textenable ? 200 : 250,
                    height: 50,
                    child: _buildnamefield(),
                  ),
                  _textenable
                      ? Row(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#BC70FF"),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _textenable = !_textenable;
                                  });
                                },
                                child: const Text("Cancel")),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#BC70FF"),
                                ),
                                onPressed: () {
                                  if (namecontrol.text.isNotEmpty) {
                                    setState(() {
                                      NAME = namecontrol.text;
                                      _textenable = !_textenable;
                                    });
                                  }
                                },
                                child: const Text("Save")),
                          ],
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#BC70FF"),
                          ),
                          onPressed: () {
                            setState(() {
                              textwidth = 200;
                              _textenable = !_textenable;
                            });
                          },
                          child:  SizedBox(
                              width: 50,
                              child: Center(child: Icon(Icons.edit,color: BGCOLOR,))))
                ],
              ),
            ),
            const Divider(
              color: Color.fromARGB(90, 188, 112, 255),
            ),
          ],
        ),
      ),
    );
  }

  _tranlationswitch(bool value) {
    setState(() {
      TRANSLATION = !TRANSLATION;
    });
    savePref();
  }

  void _modeswitch(bool value) {
    if (value) {
      setState(() {
        BGCOLOR = HexColor("#1C1C1E");
        BGCOLOR2 = HexColor("#444444");
        TEXTCOLOR = Colors.white;
        DARKMODE = true;
      });
    } else {
      setState(() {
        BGCOLOR = Colors.white;
        BGCOLOR2 = Colors.white;
        TEXTCOLOR = HexColor("#444444");
        DARKMODE = false;
      });
    }
    savePref();
  }
}
