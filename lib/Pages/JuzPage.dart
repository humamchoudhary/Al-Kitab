// ignore_for_file: unused_import, non_constant_identifier_names, unused_local_variable, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran/juz_data.dart';
import 'package:widget_mask/widget_mask.dart';
import '../Common/color.dart';
import '../main.dart';
import 'package:quran/quran.dart' as quran;

import 'SettingsPage.dart';

List ayahs = [];
List ayahnum = [];
List surahnum = [];

class JuzPage extends StatefulWidget {
  final int juznum;
  final String juzname;

  final int number_ayah;
  const JuzPage(
      {super.key,
      required this.juznum,
      required this.juzname,
      required this.number_ayah});

  @override
  State<JuzPage> createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> {
  bool _loading = false;
  late Map<int, List<int>> juzdata;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getJuzData() async {
    setState(() {
      ayahs = [];
      surahnum = [];
      ayahnum = [];
      _loading = true;
    });
    var url = Uri.parse(
        "http://api.alquran.cloud/v1/juz/${widget.juznum}/quran-uthmani");
    final response = await http.get(url);
    final decode = await json.decode(response.body) as Map<String, dynamic>;
    for (var i = 0; i < widget.number_ayah; i++) {
      setState(() {
        ayahs.add(decode["data"]["ayahs"][i]["text"]);
        surahnum.add(decode["data"]["ayahs"][i]["surah"]["number"]);
        ayahnum.add(decode["data"]["ayahs"][i]["numberInSurah"]);
      });
    }
    setState(() {
      _loading = false;
    });
    setState(() {
      juzdata = quran.getSurahAndVersesFromJuz(1);
    });
  }

  @override
  void initState() {
    super.initState();
    getJuzData();
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
            widget.juzname,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HexColor("#BC70FF")),
          ),
          backgroundColor: BGCOLOR,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                icon: Icon(
                  Icons.settings,
                  color: TEXTCOLOR,
                ))
          ],
        ),
        body: _loading
            ? ModalProgressHUD(
                inAsyncCall: _loading,
                color: Colors.transparent,
                progressIndicator:
                    CircularProgressIndicator(color: HexColor("#BC70FF")),
                child: const SizedBox(),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20, top: 8),
                  itemBuilder: _itemBuilder,
                  separatorBuilder: _separatorBuilder,
                  itemCount: ayahs.length,
                ),
              ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    return Card(
        color: BGCOLOR,
        elevation: 0,
        child: ayahnum.isNotEmpty
            ? Column(
                children: [
                  Card(
                    elevation: 0,
                    color: ayahnum[index] == 1
                        ? Color.fromARGB(162, 157, 157, 157)
                        : const Color.fromARGB(92, 170, 170, 170),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                minHeight: 25,
                                minWidth: 25,
                              ),
                              decoration: BoxDecoration(
                                color: HexColor("#BC70FF"),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    "${surahnum[index]}.${ayahnum[index]}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: BGCOLOR),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      OpenDialog(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          SizedBox(
                            width: width,
                            child: Text(ayahs[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Uthman",
                                    fontSize: 27,
                                    color: TEXTCOLOR)),
                          ),
                          Tranlation(
                            index: index,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const SizedBox());
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  OpenDialog(int index) {
    String translation = '';
    return showDialog(
        context: context,
        builder: (context) {
          // Future.delayed(Duration.zero, ()async {
          // translation =  await ;
          //     setState(() {

          //     });
          //     print("trans: $translation");
          // });
          return AlertDialog(
              title: Center(
                child: Text(
                  "",
                  style: GoogleFonts.poppins(fontSize: 15, color: TEXTCOLOR),
                ),
              ),
              content: Tranlation(
                index: index,
              ));
        });
  }
}

class Tranlation extends StatefulWidget {
  final int index;
  const Tranlation({super.key, required this.index});

  @override
  State<Tranlation> createState() => TranlationState();
}

class TranlationState extends State<Tranlation> {
  String translation = '';
  bool _loading = false;

  getTranslation(int surahnum, int ayahnum) async {
    setState(() {
      _loading = true;
    });
    final url = Uri.parse(
        "https://quranenc.com/api/v1/translation/aya/english_saheeh/$surahnum/$ayahnum");
    final response = await http.get(url);
    final data = await json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      translation = data["result"]["translation"];

      _loading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getTranslation(surahnum[widget.index], ayahnum[widget.index]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      translation.isNotEmpty
          ? Text(
              translation,
              style: GoogleFonts.poppins(fontSize: 15, color: TEXTCOLOR),
            )
          : const SizedBox(
              width: 400,
              height: 20,
            ),
    ]);
  }
}
