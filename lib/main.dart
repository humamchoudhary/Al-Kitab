// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:localstore/localstore.dart';
import 'package:quran_app/Common/netstatus.dart';
import 'package:quran_app/Pages/bookmarks.dart';
import 'package:quran_app/Pages/firststart.dart';
import 'Common/ayah.dart';
import 'Common/color.dart';
import 'Pages/HomePage.dart';
import 'Pages/QuranPage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

bool TRANSLATION = true;
Color BGCOLOR = Colors.white;
Color TEXTCOLOR = HexColor("#444444");
Color BGCOLOR2 = Colors.white;
bool DARKMODE = false;
bool FIRSTLOG = true;
String NAME = "";
bool ISNETON = true;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(applicationDocumentDir.path);
  Hive.registerAdapter(AyahBMAdapter());

  await Hive.openBox("namaztime");
  await Hive.openBox("location");
  await Hive.openBox("settings");
  await Hive.openBox("user");
  await Hive.openBox("bookmark");
  await Hive.openBox("lastread");
  await Hive.openBox("bm_wig");
  getUser();
  runApp(const QuranApp());
}

getUser() {
  var userbox = Hive.box("user");
  var data = userbox.toMap();
  if (data["name"] != null && data["firstlog"] != null) {
    NAME = data["name"];
    FIRSTLOG = data["firstlog"];
  }
}

intiazlize() async {
  await Future.delayed(const Duration(seconds: 3));
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("images/Quran.png"), context);
    return MaterialApp(
      title: 'Al Kitab',
      home: AnimatedSplashScreen(
        splash: Image.asset(
          "images/logo.png",
          width: 200,
          height: 200,
        ),
        nextScreen: const Auth(),
        duration: 1000,
      ),
      // home: FirstStart(),
    );
  }
}

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => AuthState();
}

class AuthState extends State<Auth> {
  @override
  void initState() {
    getNet();
    super.initState();
  }

  getNet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    setState(() {
      ISNETON = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FIRSTLOG
        ? const FirstStart()
        : ISNETON
            ? const NavPage()
            :NetStatus();
  }
}

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int menuindex = 1;
  final local = Localstore.instance;

  var Page = [
    const QuranPage(title: 'Al Kitab'),
    const HomePage(title: 'Al Kitab'),
    const BookMarkPage(title: 'Al Kitab')
  ];

  getPref() async {
    var setbox = Hive.box("settings");
    final items = await local.collection('local').doc('preferences').get();
    setState(() {
      if (items != null) {
        TRANSLATION = items["translation"];
        DARKMODE = items["darkmode"];
      }
      if (DARKMODE) {
        setState(() {
          BGCOLOR = HexColor("#1C1C1E");
          BGCOLOR2 = HexColor("#444444");
          TEXTCOLOR = Colors.white;
        });
      } else {
        setState(() {
          BGCOLOR = Colors.white;
          BGCOLOR2 = Colors.white;
          TEXTCOLOR = HexColor("#444444");
        });
      }
    });
  }

  @override
  void initState() {
    getPref();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getPref();
    return Scaffold(
      extendBody: true,
      body: Page[menuindex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        index: menuindex,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        buttonBackgroundColor: HexColor("#BC70FF"),
        backgroundColor: Colors.transparent,
        color: Colors.transparent,
        items: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FaIcon(
              FontAwesomeIcons.bookQuran,
              size: 30,
              color: menuindex == 0 ? BGCOLOR : HexColor("#BC70FF"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.home,
              size: 30,
              color: menuindex == 1 ? BGCOLOR : HexColor("#BC70FF"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.bookmark,
              size: 30,
              color: menuindex == 2 ? BGCOLOR : HexColor("#BC70FF"),
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            menuindex = index;
          });
        },
      ),
    );
  }
}
