import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran_app/main.dart';
import 'package:widget_mask/widget_mask.dart';
import '../Common/color.dart';
import 'package:localstore/localstore.dart';
// import 'package:location/location.dart' as loc;
import '../Common/navdrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? country;
  String? city;
  List namazNames = [
    "Fajr",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
  ];
  List namazname = [];
  List namaztiming = [];
  String? islamic_day;
  String? islamic_year;
  String? islamic_month;
  String? nownamaz = "";
  String? nownamaztime = "";
  String? nextnamaz = "";
  var temp_country;
  var temp_city;
  final local = Localstore.instance;

  bool _loading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getLocationData() async {
    var lastloc = await Geolocator.getLastKnownPosition();
    if (lastloc != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lastloc.latitude, lastloc.longitude);
      Placemark place = placemarks[0];
      setState(() {
        country = place.country;
        city = place.locality;
      });
    } else {
      getPosition();
    }
  }

  setNamazData() async {
    var namazbox = Hive.box('namaztime');
    namazbox.put(DateFormat("dd-MM-yyyy").format(DateTime.now()), {
      "nownamaz": nownamaz,
      "nownamaztime": nownamaztime,
      "nextnamaz": nextnamaz,
      "namaznamelist": namazname,
      "namaztiminglist": namaztiming,
      "i_day": islamic_day,
      "i_year": islamic_year,
      "i_month": islamic_month,
    });
  }

  getLocalNamazData() async {
    var namazbox = Hive.box('namaztime');
    var data = namazbox.get(DateFormat("dd-MM-yyyy").format(DateTime.now()));
    if (data != null) {
      setState(() {
        nownamaz = data["nownamaz"];
        nownamaztime = data["nownamaztime"];
        nextnamaz = data["nextnamaz"];
        namazname = data["namaznamelist"];
        namaztiming = data["namaztiminglist"];
        islamic_day = data["i_day"];
        islamic_month = data["i_month"];
        islamic_year = data["i_year"];
      });
    } else {
      bool error = false;

      switch (error) {
        case true:
          continue errorloop;
        errorloop:
        case false:
          try {
            getNamazTime();
          } catch (e) {
            // errorloop;
          }
      }
    }
  }

  setLocation() {
    var locbox = Hive.box("location");
    locbox.putAll({"country": country, "city": city});
  }

  getPosition() async {
    setState(() {
      temp_country = country;
      temp_city = city;
      country = null;
      city = null;
    });
    try {
      bool serviceEnabled;
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }

        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      bool ison = await Geolocator.isLocationServiceEnabled();
      if (ison) {
        var position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark place = placemarks[0];
        setState(() {
          country = place.country;
          city = place.locality;
        });
        setLocation();
      } else {
        print("x");
        await Geolocator.openLocationSettings();
        getPosition();
      }
    } catch (e) {
      setState(() {
        country = temp_country;
        city = temp_city;
      });
    }
  }

  // http://api.aladhan.com/v1/calendarByCity?city=London&country=United%20Kingdom&method=2&month=04&year=2017
  getNamazTime() async {
    setState(() {
      namazname = [];
      namaztiming = [];
    });
    if (country == null) {
      await getPosition();
    }
    // await getLocationData();
    var date = DateTime.now();
    var month = date.month;
    var year = date.year;
    final url = await Uri.parse(
        "http://api.aladhan.com/v1/calendarByCity?city=$city&country=$country&method=1&month=$month&year=$year");
    final repsonse = await http.get(url);
    final decode = await json.decode(repsonse.body) as Map<String, dynamic>;
    setState(() {
      var islamicDate = decode["data"][date.day - 1]["date"]["hijri"]["date"];
      islamic_month =
          decode["data"][(date.day - 1)]["date"]["hijri"]["month"]["en"];
      islamic_year = islamicDate.substring(6);
      islamic_day = islamicDate.substring(0, 2);
    });

    Map<String, dynamic> timing = decode["data"][(date.day - 1)]["timings"];
    bool namazfound = false;

    timing.forEach((key, value) async {
      setState(() {
        if (namazNames.contains(key)) {
          namazname.add(key);
          namaztiming.add(value.substring(0, 5));
        }
      });
      var t1 = DateTime.parse(
          '2000-01-01 ${DateFormat("HH:mm").format(DateFormat("HH:mm").parse(value.substring(0, 5)))}');
      var t2 = DateTime.parse(
          '2000-01-01 ${DateFormat("HH:mm").format(DateTime.now())}');

      if (!namazfound) {
        if (t1.isBefore(t2) || t1.isAtSameMomentAs(t2)) {
          setState(() {
            nownamaz = key;
            nownamaztime = value.substring(0, 5);
            if (nownamaz == "Isha") {
              nextnamaz = "Fajr";
            }
          });
        }
      }
    });
    if (namazname.length > 5) {
      setState(() {
        namazname.removeRange(5, namazname.length);
        namaztiming.removeRange(5, namaztiming.length);
      });
    }
    setNamazData();
  }

  checkNamazUpdates() {
    bool namazfound = false;
    for (int i = 0; i < namaztiming.length; i++) {
      var t1 = DateTime.parse(
          '2000-01-01 ${DateFormat("HH:mm").format(DateFormat("HH:mm").parse(namaztiming[i]))}');
      var t2 = DateTime.parse(
          '2000-01-01 ${DateFormat("HH:mm").format(DateTime.now())}');

      if (t1.isBefore(t2) || t1.isAtSameMomentAs(t2)) {
        setState(() {
          nownamaz = namazname[i];
          nownamaztime = namaztiming[i];
          namazfound = true;
          if (nownamaz == "Isha") {
            nextnamaz = "Fajr";
          }
        });
        setNamazData();
      } else if (t1.isAfter(t2)) {
        nextnamaz = namazname[i];
      }
    }
  }

  var date = DateFormat.yMMMMd('en_US').format(DateTime.now());
  var day = DateFormat('EEEE').format(DateTime.now());
  @override
  void initState() {
    getPosition();
    // checkperm();
    getLocalNamazData();
    checkNamazUpdates();
    Timer.periodic(const Duration(seconds: 15), (Timer t) {
      checkNamazUpdates();
    });
    super.initState();
  }

  List<TableRow> _buildNamaztimingtile() {
    List<TableRow> rows = [];
    for (int i = 0; i < namazname.length; ++i) {
      setState(() {
        rows.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                "${namazname[i]}",
                style: GoogleFonts.poppins(
                    color: TEXTCOLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                "${namaztiming[i]}",
                style: GoogleFonts.poppins(
                    color: TEXTCOLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ]));
      });
    }
    return rows;
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
      body: _loading || namazname.isEmpty
          ? ModalProgressHUD(
              inAsyncCall: _loading || namazname.isEmpty,
              color: Colors.transparent,
              progressIndicator:
                  CircularProgressIndicator(color: HexColor("#BC70FF")),
              child: Container(
                color: BGCOLOR,
                width: width,
                height: height,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 400,
                        child: AppBar(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          flexibleSpace: WidgetMask(
                            mask: SizedBox(
                                child: Image.asset(
                              "images/Mask Group 3.png",
                              alignment: Alignment.bottomRight,
                            )),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                    gradient: LinearGradient(
                                      end: Alignment.center,
                                      begin: Alignment.topLeft,
                                      colors: [
                                        HexColor("#EDA1FF"),
                                        HexColor("#BC70FF"),
                                      ],
                                    ))),
                          ),
                          title: Text(
                            "Home",
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 100, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                                width: width,
                                child: Text(
                                  "Now",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 22),
                                )),
                            Column(
                              children: [
                                SizedBox(
                                    width: width,
                                    child: Text(
                                      "$nownamaz",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                    width: width,
                                    child: Text(
                                      "$nownamaztime",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                width: width,
                                child: Text(
                                  "Upcoming:",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 12),
                                )),
                            Column(
                              children: [
                                SizedBox(
                                    width: width,
                                    child: Text(
                                      "$nextnamaz",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                                width: width,
                                child: Text(
                                  "Assalamualaikum",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 18),
                                )),
                            SizedBox(
                                width: width,
                                child: Text(
                                  NAME,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                width: width,
                                child: islamic_day == null ||
                                        islamic_month == null
                                    ? const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: SizedBox(
                                            width: 2,
                                            child: PlaceholderLines(
                                              maxWidth: 0.04,
                                              minWidth: 0.04,
                                              count: 1,
                                              lineHeight: 15,
                                              animate: true,
                                            )),
                                      )
                                    : Text(
                                        "$islamic_day",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      )),
                            SizedBox(
                                width: width,
                                child: islamic_year == null ||
                                        islamic_month == null
                                    // ignore: prefer_const_constructors
                                    ? SizedBox(
                                        width: 15,
                                        child: const PlaceholderLines(
                                          maxWidth: 0.1,
                                          minWidth: 0.1,
                                          count: 1,
                                          lineHeight: 15,
                                          animate: true,
                                        ))
                                    : Text(
                                        "$islamic_month, $islamic_year",
                                        style: const TextStyle(
                                            fontFamily: "ReaderPro",
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                            SizedBox(
                                width: width,
                                child: Text(
                                  date,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )),
                            SizedBox(
                                width: width,
                                child: Text(
                                  day,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      color: BGCOLOR2,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                "$day, $date",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: TEXTCOLOR,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    city == null || country == null
                                        ? const SizedBox(
                                            width: 160,
                                            child: PlaceholderLines(
                                              count: 1,
                                              lineHeight: 15,
                                              animate: true,
                                            ))
                                        : Text(
                                            "$city, $country",
                                            style: GoogleFonts.poppins(
                                                color: TEXTCOLOR,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        _loading = true;
                                      });

                                      await getNamazTime();
                                      setState(() {
                                        _loading = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: TEXTCOLOR,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(124, 158, 158, 158),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Table(children: [
                                  TableRow(children: [
                                    Center(
                                      child: Text(
                                        "Salah",
                                        style: GoogleFonts.poppins(
                                            color: TEXTCOLOR,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Timing",
                                        style: GoogleFonts.poppins(
                                            color: TEXTCOLOR,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ]),
                                ]),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            namazname[0] != null
                                ? Table(
                                    children: _buildNamaztimingtile(),
                                  )
                                : SizedBox(
                                    height: 50,
                                    child: Text(
                                      "Loading Namaz Timing",
                                      style: GoogleFonts.poppins(
                                          color: TEXTCOLOR,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
    );
  }
}
