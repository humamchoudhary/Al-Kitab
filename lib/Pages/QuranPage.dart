// ignore_for_file: file_names
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran/surah_data.dart';
import 'package:quran_app/Common/color.dart';
import 'package:quran_app/Pages/JuzPage.dart';
import 'package:quran_app/Pages/SurahPage.dart';
import 'package:quran_app/main.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:quran/quran.dart' as quran;

import '../Common/navdrawer.dart';

// ignore: non_constant_identifier_names
bool _loadingaudio = true;
String? name = "Abdulrahman Al sudaes";
var names = [
  'Abdulrahman Al sudaes',
  'Ibrahim Al-Akdar',
  'Mishary Al afasi',
];
List links = [
  "https://server11.mp3quran.net/sds/",
  "https://server6.mp3quran.net/akdr/",
  "https://server8.mp3quran.net/afs/"
];

class QuranPage extends StatefulWidget {
  final String title;
  const QuranPage({
    super.key,
    required this.title,
  });

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  String? lastread = "Al-Fatiah";
  int lastreadsurahnum = 2;

  String test = "قَدْ سَمِعَ ٱللهُ";
  List<bool> Active = [true, false, false];
  int? lastreadayah = 9;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    print(quran.getJuzURL(1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      drawer: NavDrawer(
        title: widget.title,
      ),
      backgroundColor: BGCOLOR,
      appBar: AppBar(
        iconTheme: IconThemeData(color: TEXTCOLOR),
        elevation: 0,
        title: Text(
          "Quran",
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor("#BC70FF")),
        ),
        backgroundColor: BGCOLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8),
        child: Column(children: [
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurahPage(
                            surahnumber: lastreadsurahnum,
                            lastread: true,
                            index: lastreadayah,
                          )));
            },
            child: WidgetMask(
              mask: SizedBox(
                  child: Image.asset(
                "images/Mask Group 2.png",
                alignment: Alignment.bottomRight,
              )),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        end: Alignment.center,
                        begin: Alignment.topLeft,
                        colors: [
                          HexColor("#EDA1FF"),
                          HexColor("#BC70FF"),
                        ],
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: SizedBox(
                        width: width,
                        height: 190,
                        child: ValueListenableBuilder(
                          builder: (context, box, child) {
                            getLastRead();
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.book_outlined,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Last Read",
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "$lastread",
                                    style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Ayah No. $lastreadayah",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                ]);
                          },
                          valueListenable: Hive.box("lastread").listenable(),
                        )),
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Table(
            children: [
              TableRow(children: [
                InkWell(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Surah",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: TEXTCOLOR),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Active[0]
                          ? Container(
                              height: 2,
                              color: HexColor("#BC70FF"),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      Active = [true, false, false];
                    });
                  },
                ),
                InkWell(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Parah",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: TEXTCOLOR),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Active[1]
                          ? Container(
                              height: 2,
                              color: HexColor("#BC70FF"),
                            )
                          : const SizedBox()
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      Active = [false, true, false];
                    });
                  },
                ),
                InkWell(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Audio",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: TEXTCOLOR),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Active[2]
                          ? Container(
                              height: 2,
                              color: HexColor("#BC70FF"),
                            )
                          : const SizedBox()
                    ],
                  ),
                  onTap: () {
                    print(quran.getAudioURLByVerse(1, 1));
                    setState(() {
                      Active = [false, false, true];
                    });
                  },
                ),
              ])
            ],
          ),
          Active[0]
              ? Expanded(
                  child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: surahitemBuilder,
                      separatorBuilder: separatorBuilder,
                      itemCount: quran.totalSurahCount),
                )
              : const SizedBox(),
          Active[1]
              ? Expanded(
                  child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: juzitemBuilder,
                      separatorBuilder: separatorBuilder,
                      itemCount: quran.totalJuzCount),
                )
              : const SizedBox(),
          const SizedBox(
            height: 5,
          ),
          Active[2]
              ? Expanded(
                  child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: audioItemBuilder,
                      separatorBuilder: separatorBuilder,
                      itemCount: quran.totalSurahCount + 1),
                )
              : const SizedBox(),
          const SizedBox(
            height: 5,
          ),
        ]),
      ),
    );
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return const Divider(thickness: 1.5);
  }

  Widget surahitemBuilder(BuildContext context, int index) {
    return ListItemSurah(index: index);
  }

  Widget juzitemBuilder(BuildContext context, int index) {
    return ListItemJuz(index: index);
  }

  void getLastRead() {
    var lrbox = Hive.box("lastread");
    if (lrbox.isNotEmpty) {
      lastread = lrbox.get("surahname");
      lastreadsurahnum = lrbox.get("surahnumber");
      lastreadayah = lrbox.get("surahnumber");
    }
  }

  Widget audioItemBuilder(BuildContext context, int index) {
    return ListItemAudio(index: index);
  }
}

class ListItemSurah extends StatefulWidget {
  final int index;
  const ListItemSurah({super.key, required this.index});

  @override
  State<ListItemSurah> createState() => _ListItemSurahState();
}

class _ListItemSurahState extends State<ListItemSurah> {
  bool click = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SurahPage(
                      surahnumber: widget.index + 1,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: Text(
            "${widget.index + 1}",
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w300, color: TEXTCOLOR),
          ),
          title: Text(
            quran.getSurahName(widget.index + 1),
            style: GoogleFonts.poppins(fontSize: 18, color: TEXTCOLOR),
          ),
          subtitle: Text(
            "verses ${quran.getVerseCount(widget.index + 1)}",
            style: GoogleFonts.poppins(fontSize: 12, color: TEXTCOLOR),
          ),
        ),
      ),
    );
  }
}

class ListItemJuz extends StatefulWidget {
  final int index;

  const ListItemJuz({super.key, required this.index});

  @override
  State<ListItemJuz> createState() => _ListItemJuzState();
}

class _ListItemJuzState extends State<ListItemJuz> {
  List<String> juzNames = [
    "آلم",
    "سَيَقُولُ",
    "تِلْكَ ٱلْرُّسُلُ",
    "لن تنالوا",
    "وَٱلْمُحْصَنَاتُ",
    "لَا يُحِبُّ ٱللهُ",
    "وَإِذَا سَمِعُوا",
    "وَلَوْ أَنَّنَا",
    "قَالَ ٱلْمَلَأُ",
    "وَٱعْلَمُواْ",
    "يَعْتَذِرُونَ",
    "وَمَا مِنْ دَآبَّةٍ",
    "وَمَا أُبَرِّئُ",
    "رُبَمَا",
    "سُبْحَانَ ٱلَّذِى",
    "قَالَ أَلَمْ",
    "ٱقْتَرَبَ لِلْنَّاسِ",
    "قَدْ أَفْلَحَ",
    "وَقَالَ ٱلَّذِينَ",
    "أَمَّنْ خَلَقَ",
    "أُتْلُ مَاأُوْحِیَ",
    "وَمَنْ يَّقْنُتْ",
    "وَمَآ لي",
    "فَمَنْ أَظْلَمُ",
    "إِلَيْهِ يُرَدُّ",
    "حم",
    "قَالَ فَمَا خَطْبُكُم",
    "قَدْ سَمِعَ ٱللهُ",
    "تَبَارَكَ ٱلَّذِى",
    "عَمَّ",
  ];
  bool click = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var icon = Icons.favorite_border;
    int versecount = 0;
    Map<int, List<int>> juzdata =
        quran.getSurahAndVersesFromJuz(widget.index + 1);
    juzdata.forEach((key, value) {
      versecount += value[1] - (value[0] - 1);
    });
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JuzPage(
                      juznum: widget.index + 1,
                      juzname: juzNames[widget.index],
                      number_ayah: versecount,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: Text(
            "${widget.index + 1}",
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w300, color: TEXTCOLOR),
          ),
          title: Text(
            juzNames[widget.index],
            style: GoogleFonts.poppins(fontSize: 18, color: TEXTCOLOR),
          ),
          subtitle: Text(
            "verses $versecount",
            style: GoogleFonts.poppins(fontSize: 12, color: TEXTCOLOR),
          ),
        ),
      ),
    );
  }
}
// [null, null, 0, 1, 2, 0, 1]

class ListItemAudio extends StatefulWidget {
  final int index;

  const ListItemAudio({super.key, required this.index});

  @override
  State<ListItemAudio> createState() => _ListItemAudioState();
}

class _ListItemAudioState extends State<ListItemAudio> {
  AudioPlayer player = AudioPlayer();
  Duration? pos = const Duration();

  int linkindex = 0;
  bool playing = false;
  final snackBar = SnackBar(
    content: Text(
      "Loading Audio",
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: HexColor("#BC70FF"),
      ),
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8))),
    backgroundColor: TEXTCOLOR,
    duration: const Duration(days: 365),
  );

  @override
  Widget build(BuildContext context) {
    print("x: $name");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.index == 0
          ? DropdownButton(
              isExpanded: true,
              dropdownColor: BGCOLOR,
              underline: const SizedBox(),
              elevation: 3,
              style: GoogleFonts.poppins(fontSize: 18, color: TEXTCOLOR),
              value: name,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: names.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items,
                    style: GoogleFonts.poppins(fontSize: 18, color: TEXTCOLOR),
                  ),
                );
              }).toList(),
              onChanged: (value) => setVal(value))
          : ListTile(
              leading: IconButton(
                  icon: Icon(
                      playing
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined,
                      color: HexColor("#BC70FF"),
                      size: 25),
                  onPressed: () {
                    startplay();
                  }),
              title: Text(
                quran.getSurahName(widget.index),
                style: GoogleFonts.poppins(fontSize: 18, color: TEXTCOLOR),
              ),
              trailing: IconButton(
                icon: Icon(Icons.refresh_rounded, color: HexColor("#BC70FF")),
                onPressed: () {
                  setState(() {
                    player.seek(const Duration());
                  });
                },
              ),
            ),
    );
  }

  startplay() async {
    setState(() {
      linkindex = names.indexOf(name!);
    });
    print(linkindex);
    print(name);
    print(playing);
    if (playing) {
      player.pause();
      pos = await player.getCurrentPosition();
      setState(() {
        player.seek(Duration(seconds: pos!.inSeconds.toInt()));

        playing = false;
      });
    } else {
      var url = "";
      if ("${widget.index}".length == 1) {
        url = links[linkindex] + "00${widget.index}.mp3";
      } else if ("${widget.index}".length == 2) {
        url = links[linkindex] + "0${widget.index}.mp3";
      } else {
        url = links[linkindex] + "${widget.index}.mp3";
      }
      print(url);
      setState(() {
        _loadingaudio = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await player.play(UrlSource(url)).then(
          (value) => ScaffoldMessenger.of(context).removeCurrentSnackBar());
      setState(() {
        playing = true;
      });
    }
  }

  setVal(String? value) {
    setState(() {
      name = value;
    });
  }
}
