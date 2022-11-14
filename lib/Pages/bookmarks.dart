import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran_app/Common/ayah.dart';
import '../Common/color.dart';
import '../Common/navdrawer.dart';
import 'package:quran/quran.dart' as quran;
import '../main.dart';

class BookMarkPage extends StatefulWidget {
  final String title;
  const BookMarkPage({super.key, required this.title});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  List<AyahBM> ayahlist = [];

  bool _loading = false;

  @override
  void initState() {
    getbookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: NavDrawer(
        title: widget.title,
      ),
      backgroundColor: BGCOLOR,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: TEXTCOLOR, //change your color here
        ),
        elevation: 0,
        title: Text(
          "BookMarks",
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor("#BC70FF")),
        ),
        backgroundColor: BGCOLOR,
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
              child: ayahlist.isEmpty
                  ? Center(
                      child: Text(
                        "No BookMarks",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: TEXTCOLOR),
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: itemBuilder,
                      itemCount: ayahlist.length,
                      separatorBuilder: separatorBuilder,
                    ),
            ),
    );
  }

  getbookmarks() {
    setState(() {
      _loading = true;
    });
    var bmwidbox = Hive.box("bm_wig");
    bmwidbox.toMap().forEach((key, value) {
      value.forEach((key2, val2) {
        setState(() {
          ayahlist.add(val2);
        });
      });
    });
    setState(() {
      _loading = false;
    });
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    return Card(
        color: BGCOLOR,
        elevation: 0,
        child: ayahlist.isNotEmpty
            ? InkWell(
                child: Column(
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
                                    "${ayahlist[index].surahnum}.${ayahlist[index].ayahnum}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, color: BGCOLOR),
                                  ),
                                ),
                              ),
                              Text(
                                quran.getSurahNameArabic(
                                    ayahlist[index].surahnum),
                                style: TextStyle(
                                    fontFamily: "Uthman",
                                    fontSize: 30,
                                    color: TEXTCOLOR,
                                    fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                onPressed: () {
                                  removebookmark(index);
                                },
                                icon: Icon(
                                  Icons.bookmark,
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
                            child: Text(ayahlist[index].ayah,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontFamily: "Uthman",
                                    fontSize: 27,
                                    color: TEXTCOLOR)),
                          ),
                          SizedBox(
                            width: width,
                            child: Text(
                              "${ayahlist[index].translation}",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: TEXTCOLOR),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: Text(
                  "No Bookmarks Found",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(fontSize: 15, color: TEXTCOLOR),
                ),
              ));
  }

  void removebookmark(int index) {
    var bmbox = Hive.box("bookmark");
    var bmwidbox = Hive.box("bm_wig");
    Map bmWidMap = bmwidbox.toMap()[ayahlist[index].surahnum];
    bmWidMap.remove(ayahlist[index].ayahnum - 1);
    bmwidbox.put(ayahlist[index].surahnum, bmWidMap);

    // bmwidbox.delete(ayahlist[index].ayahnum - 1);

    // bmbox.delete(ayahlist[index].ayahnum);
    Map bmMap = bmbox.toMap()[ayahlist[index].surahnum];
    bmMap[ayahlist[index].ayahnum - 1] = !bmMap[ayahlist[index].ayahnum - 1];
    bmbox.put(ayahlist[index].surahnum, bmMap);
    setState(() {
      ayahlist.removeAt(index);
    });
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: "Bookmark removed",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: HexColor("#BC70FF"),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
