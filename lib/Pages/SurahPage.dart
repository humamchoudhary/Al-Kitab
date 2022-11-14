// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_app/Common/ayah.dart';
import 'package:quran_app/Pages/SettingsPage.dart';
import 'package:quran_app/main.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:http/http.dart' as http;
import '../Common/color.dart';
import 'package:audioplayers/audioplayers.dart';

class SurahPage extends StatefulWidget {
  const SurahPage(
      {super.key,
      this.surahnumber,
      this.translation,
      this.lastread = false,
      this.index});
  final index;
  final surahnumber;
  final translation;
  final lastread;

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List Translation = [];
  bool _loading = false;
  List bmlist = [];
  AudioPlayer player = AudioPlayer();
  String? url;


  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final scrollController = ItemScrollController();
  Future scrollTo() async {
    if (scrollController.isAttached) {
      scrollController.scrollTo(
          index: widget.index,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    setInitial();
    getTranslation();
    updateBookmark();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (widget.lastread) {
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollTo());
    }

    return Scaffold(
      backgroundColor: BGCOLOR,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: TEXTCOLOR,
        ),
        elevation: 0,
        title: Text(
          quran.getSurahName(widget.surahnumber),
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
              child: Container(
                color: BGCOLOR,
                width: width,
                height: height,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
              ),
              child: ScrollablePositionedList.separated(
                  padding: const EdgeInsets.only(bottom: 20, top: 8),
                  itemBuilder: itemBuilder,
                  separatorBuilder: separatorBuilder,
                  itemScrollController: scrollController,
                  itemCount: quran.getVerseCount(widget.surahnumber) + 1),
            ),
    );
  }

  getTranslation() async {
    setState(() {
      _loading = true;
      Translation = [];
    });
    Uri url = Uri.parse(
        "https://quranenc.com/api/v1/translation/sura/english_rwwad/${widget.surahnumber}");
    var response = await http.get(url);
    final decode = await json.decode(response.body) as Map<String, dynamic>;
    final data = await decode["result"];
    // print(data.length);
    for (var value in data) {
      setState(() {
        Translation.add(value["translation"]);
      });
    }
    setState(() {
      _loading = false;
    });
  }
  @override
  void dispose() {
    player.pause();
    print("x");
    super.dispose();
  }

  Widget itemBuilder(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;

    return Card(
        color: BGCOLOR,
        elevation: 0,
        child: InkWell(
          onTap: () async {
            bool result = await InternetConnectionChecker().hasConnection;
            if (result&&ModalRoute.of(context)!.isActive) {
              String url  = quran.getAudioURLByVerse(widget.surahnumber, index);
              print(url);
              player.play(UrlSource(url!));
            } else {
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                  msg: "Internet is required",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: HexColor("#BC70FF"),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          onDoubleTap: () {
            setLastRead(index);
          },
          child: index == 0
              ? WidgetMask(
                  mask: SizedBox(
                      child: Image.asset(
                    "images/Mask Group 1.png",
                    alignment: Alignment.bottomRight,
                  )),
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20)),
                            gradient: LinearGradient(
                              end: Alignment.center,
                              begin: Alignment.topLeft,
                              colors: [
                                HexColor("#EDA1FF"),
                                HexColor("#BC70FF"),
                              ],
                            )),
                        child: SizedBox(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 20),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    quran.getSurahNameArabic(widget.surahnumber),
                                    style: const TextStyle(
                                        fontFamily: "Uthman",
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    quran.getSurahName(widget.surahnumber),
                                    style: GoogleFonts.poppins(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Number of verses ${quran.getVerseCount(index + 1)}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Recitation by: Mishary Alafasi",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Translation by: Rowwad Translation Center",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(quran.basmala,
                                      style: TextStyle(
                                          fontFamily: "Uthman",
                                          fontSize: 30,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )))
              : Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: const Color.fromARGB(92, 170, 170, 170),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#BC70FF"),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${(index)}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: BGCOLOR),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Addbookmark(index - 1);
                                },
                                icon: Icon(
                                  bmlist[index - 1]
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color: HexColor("#BC70FF"),
                                ),
                              )
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          SizedBox(
                            width: width,
                            child: Text(
                                quran.getVerse(widget.surahnumber, index),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontFamily: "Uthman",
                                    fontSize: 27,
                                    color: TEXTCOLOR)),
                          ),
                          TRANSLATION
                              ? Translation.isEmpty
                                  ? SizedBox(
                                      width: width,
                                      child: const PlaceholderLines(
                                        count: 1,
                                        lineHeight: 15,
                                        animate: true,
                                      ))
                                  : SizedBox(
                                      width: width,
                                      child: Text(
                                        "${Translation[index - 1]}",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15, color: TEXTCOLOR),
                                      ),
                                    )
                              : const SizedBox(
                                  height: 10,
                                ),
                        ],
                      ),
                    )
                  ],
                ),
        ));
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void Addbookmark(int index) {
    var bmbox = Hive.box("bookmark");
    var surahbooks = bmbox.get(widget.surahnumber);
    surahbooks[index] = !surahbooks[index];
    bmbox.put(widget.surahnumber, surahbooks);

    var no_bm = bmbox.get("book_num");
    no_bm ??= 0;
    updateBookmark();
    Fluttertoast.cancel();
    if (surahbooks[index]) {
      saveBookmarkWidget(index);
      no_bm += 1;
      Fluttertoast.showToast(
          msg: "Bookmark added",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: HexColor("#BC70FF"),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      removeBookmarkWidget(index);
      no_bm -= 1;
      Fluttertoast.showToast(
          msg: "Bookmark removed",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: HexColor("#BC70FF"),
          textColor: Colors.white,
          fontSize: 16.0);
    }
    bmbox.put("book_num", no_bm);
  }

  saveBookmarkWidget(int index) {
    var bmbox = Hive.box("bm_wig");
    AyahBM ayah = AyahBM(quran.getVerse(widget.surahnumber, index + 1),
        index + 1, widget.surahnumber, Translation[index]);
    Map bmMap = bmbox.toMap();
    bmMap[widget.surahnumber][index] = ayah;
    bmbox.putAll(bmMap);
  }

  removeBookmarkWidget(int index) {
    var bmbox = Hive.box("bm_wig");
    Map bmMap = bmbox.toMap()[widget.surahnumber];
    bmMap.remove(index);
    bmbox.put(widget.surahnumber, bmMap);
  }

  updateBookmark() {
    var bmbox = Hive.box("bookmark");
    Map bm = bmbox.toMap();
    if (bm[widget.surahnumber] != null) {
      bm = bm[widget.surahnumber];
      List templist = [];
      bm.forEach((key, value) {
        templist.add(value);
      });
      setState(() {
        bmlist = templist;
      });
    }
  }

  getBookmark(int index) {
    var bmbox = Hive.box("bookmark");
    var surahbooks = bmbox.get(widget.surahnumber);
    if (surahbooks != null) {
      if (surahbooks[index] == null) {
        surahbooks[index] = false;
        bmbox.put(widget.surahnumber, surahbooks);
      }
    } else {
      surahbooks = {index: false};
      bmbox.put(widget.surahnumber, surahbooks);
    }
    Map bm = bmbox.toMap()[widget.surahnumber];
    List templist = [];
    bm.forEach((key, value) {
      templist.add(value);
    });
    bmlist = templist;
  }

  void setInitial()async {

    setState(() {
      _loading = true;
    });


    var bmbox = Hive.box("bookmark");
    Map temp = {};
    if (bmbox.isEmpty) {
      bmbox.put(widget.surahnumber, {});
    } else if (!bmbox.containsKey(widget.surahnumber) ||
        bmbox.get(widget.surahnumber).isEmpty) {
      for (var i = 0; i < quran.getVerseCount(widget.surahnumber); i++) {
        temp[i] = false;
        setState(() {
          bmlist.add(false);
        });
      }
      bmbox.put(widget.surahnumber, temp);
    }
    // bmbox.clear();
    setState(() {
      _loading = false;
    });
  }

  void setLastRead(index) {
    var lrbox = Hive.box("lastread");
    lrbox.clear();
    lrbox.putAll({
      "surahname": quran.getSurahName(widget.surahnumber),
      "surahnumber": widget.surahnumber,
      "ayahnumber": index
    });
    Fluttertoast.cancel();

    Fluttertoast.showToast(
        msg: "Last Seen added",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: HexColor("#BC70FF"),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
