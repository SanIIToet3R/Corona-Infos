import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Logik/DataForHomeScreen.dart';
import 'package:flutter_app/Logik/Datenabfrage_lk.dart';
import 'package:flutter_app/Logik/LocationForData.dart';
import 'package:sqflite/sqflite.dart';
import 'API/RKIAPILK.dart';
import 'Logik/database_helper.dart';
import 'verhaltensregeln.dart';
import 'to_do_liste.dart';
import 'fallzahlenerstellen.dart';
import 'symptome.dart';
import 'GlobalStatistik.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'pdf_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/API/tools.dart' as tools;

class IconLinearGradientMask extends StatelessWidget {
  IconLinearGradientMask({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF7879F1), Color(0xFFFF0000)],
      ).createShader(bounds),
      child: child,
    );
  }
}

//Variable fuer den Pfad der PDF
const String _documentPath = 'PDFs/Datenschutzerklarung.pdf';

//Klasse fuer die Datenschutzerklaerung
class homepagepdf extends StatelessWidget {
  final BuildContext context;

  const homepagepdf(this.context);

  Future<String> prepareTestPdf() async {
    final ByteData bytes =
    await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';

    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);

    return tempDocumentPath;
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Container(
      // margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white.withOpacity(0.3),
        textColor: Colors.black,
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment(-1, -0.4),
              child: Text('Datenschutzerklärung',
                  style: TextStyle(
                      fontSize: data.size.height / 35, fontFamily: 'Roboto'))),
          Align(
              alignment: Alignment(-1, 0.5),
              child: Text('Datenschutzerklärung für \ndie Corona-Infos App',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: data.size.height / 51,
                      fontFamily: 'Roboto'))),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.policy,
              size: data.size.height / 12,
              color: Colors.grey,
            ),
          ),
        ]),
        onPressed: () async {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          var path = await prepareTestPdf();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PdfScreenPage(path)),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  Landkreis currentLk;

  String _casesAtLocation = "Lädt...";
  String _lastUpdate = "";
  String _note = "";
  String _risk = "Lädt...";
  bool _lowinzidenz = true;

  String _zipCode;
  String _locality = "Lädt...";
  String _nameOfCurrentLk;

  @override
  void initState() {
    super.initState();
    getDataToShowOnHome();
  }

  /*
   * Diese Methode ruft diverse Untermethoden auf, um die Daten fuer die dynamischen Informatuonen
   * auf dem Homescreen sowie das Aendern der Hintergrundfarben zu ermoeglichen.
   */
  void getDataToShowOnHome() async {
    print("Starting procedure to get location based information...");
    //Ermittle die PLZ und den Ortsnamen der aktuelle Geraeteposition
    LocationForData lcd = new LocationForData();
    await lcd.getCurrentLocationZip();
    this._zipCode = lcd.currentLocationZip;
    setState(() {
      //aktualisiere den State mit den neuen  --> Der Ortsname wird direkt nach kurzer Zeit angezeigt
      this._locality = "Ihr Standort: " + lcd.currentLocationCity;
      print("getting of location data done. Processing db request...");
    });

    // Fuehere mit den erhaltenen Daten eine Abfrage in der DB aus, um
    // den Namen des aktuellen LKs zu erhalten. Dafuer wird die PLZ verwendet anhand derer
    // sich der zugehoerige Landkreis ermitteln lässt.
    this._nameOfCurrentLk = await _queryDataWithZip();
    print("Current Landkreis ist $_nameOfCurrentLk. Processing case-request");

    //Frage anhand des Landkreisnamens die Daten aus der API ab
    Datenabfrage_lk dataForHomeScreen = new Datenabfrage_lk();
    this.currentLk =
    await dataForHomeScreen.selectLKforHomescreen("$_nameOfCurrentLk", context);

    //Falls kein keine Daten vorliegen bzw. gefunden werden koennen, gib dem User ein Feedback aus
    if (this.currentLk == null) {
      print("current location could not be found within available data");
      tools.showAlertDialog(
          title: "Ortungsfehler",
          content:
          "Ihre Position ist nicht in unserem Datensatz vorhanden. Wir bitten um Entschuldigung.",
          context: context);
    } else {

      //Aktualisere den State anhand der volriegenden Daten, sofern Daten gefunden
      //worden sind und zeige sie dem Nutzer dadurch an.
      print("passing fitting data...");
      String noteFromCurrentCases =
          "Halten Sie sich an die \naktuellen Vorgaben";
      String riskFromCurrentCases = "Geringes Risiko";
      bool currentbackground = true;
      if (this.currentLk.cases7_per_100k >= 100) {
        noteFromCurrentCases =
        "Meiden Sie umbedingt Kontakt \nzu anderen Menschen";
        riskFromCurrentCases = "Erhöhtes Risiko";
        currentbackground = false;
      }
      if (this.currentLk.cases7_per_100k >= 150) {
        riskFromCurrentCases = "Hohes Risiko";
      }
      setState(() {
        this._casesAtLocation = "Aktuelle Inzidenz: " +
            this.currentLk.cases7_per_100k.toStringAsFixed(2);
        this._lastUpdate = "" + this.currentLk.GEN + " am: " + this.currentLk.last_update;
        this._note = noteFromCurrentCases;
        this._risk = riskFromCurrentCases;
        this._lowinzidenz = currentbackground;
      });
    }
    print("Processing for Homescreen complete.");
  }

  /*
   * Fragt anhand der vorhandenen PLZ die Datenbank nach dem zur PLZ gehoerenden
   * Landkreise ab.
   */
  Future<String> _queryDataWithZip() async {
    print("Smartphone locations zip is $_zipCode");
    List<Map<String, dynamic>> zipLkr = await dbHelper.queryZipToLkr("$_zipCode");
    //Die Liste wird aufgrund der Eindeutigkeit der PLZ immer nur ein Element in Form eines Map-Objekts enthalten koennen,
    //Daher kann ueber den Index 0 ohne weiter Fallunterscheidungen auf dieses Element zugegriffen werden.
    DataForHomeScreen dfh = DataForHomeScreen.fromDB(zipLkr.elementAt(0));
    return dfh.lkName;
  }

  //Das Widget detectBG soll die Hintergrundfarbe anhand der Inzidenz auswaehlen
  Widget _detectBG() {
    if (_lowinzidenz) {
      return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF04B800),
                  Color(0xFF003100),
                ]),
          ));
    } else {
      return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFFFC3B45),
                  Color(0xFF6B1758),
                ]),
          ));
    }
  }

  void checkGPS(BuildContext context) async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled) {
      // service enabled
    } else {
      tools.showAlertDialog(
          title: 'GPS-Fehler',
          content:
          'GPS-Funktionen sind nicht nutzbar. Bitte schalten Sie dafür ihr GPS an.',
          context: context);
      // service not enabled, restricted or permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context); //Endgerät daten z.b größe
    checkGPS(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Banner Oben rechts
      title: 'HomeScreen',
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            _detectBG(),
            ListView( //ListView fuer scrollbare Ansicht
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: data.size.width,
                  height: data.size.height / 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius:
                    const BorderRadius.all(const Radius.circular(6)),
                  ),
                  child: Stack(children: <Widget>[
                    Container( //Container fuer oberen Bereich des Homescreens
                      width: 350,
                      child: Align(
                          alignment: Alignment(-0.2, -0.8),
                          child: Text("$_locality",
                              //ToDo: Dynamisch an Ort anpassen
                              style: TextStyle(
                                  fontSize: data.size.width / 25,
                                  fontFamily: 'Roboto'))),
                    ),
                    Align(
                        alignment: Alignment(-0.60, -0.3),
                        child: Text('$_casesAtLocation',
                            style: TextStyle(
                                fontSize: data.size.width / 25,
                                fontFamily: 'Roboto'))),
                    Align(
                        alignment: Alignment(-0.35, -0.05),
                        child: Text('$_lastUpdate',
                            style: TextStyle(
                                fontSize: data.size.width / 30,
                                fontFamily: 'Roboto',
                                color: Color(0x42000000)))),
                    Align(
                        alignment: Alignment(-0.67, 0.275),
                        child: Text('$_risk',
                            style: TextStyle(
                                fontSize: data.size.width / 25,
                                fontFamily: 'Roboto'))),
                    Align(
                        alignment: Alignment(-0.65, 0.7),
                        child: Text('$_note',
                            style: TextStyle(
                                fontSize: data.size.width / 35,
                                fontFamily: 'Roboto',
                                color: Color(0x42000000)))),
                    Align(
                        alignment: Alignment(-0.95, -0.8),
                        child: Icon(
                          Icons.my_location_rounded,
                          color: Colors.red[700],
                          size: data.size.height / 28,
                        )),
                    Align(
                        alignment: Alignment(-0.95, -0.3),
                        child: Icon(
                          Icons.shuffle_rounded,
                          color: Colors.orange,
                          size: data.size.height / 28,
                        )),
                    Align(
                        alignment: Alignment(-0.95, 0.3),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Color(0xA6FFE600),
                          size: data.size.height / 28,
                        )),
                    Align(
                        alignment: Alignment(0.85, 1),
                        child: Text('Robert Koch-Institut (RKI), dl-de/by-2-0',
                            style: TextStyle(
                                fontSize: data.size.height / 70,
                                fontFamily: 'Roboto'))),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                    width: data.size.width,
                    height: data.size.height / 8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white.withOpacity(0.3),
                      textColor: Colors.black,
                      elevation: 4.0,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment(-1, -0.5),
                            child: Text('Verhaltensregeln',
                                style: TextStyle(
                                    fontSize: data.size.height / 35,
                                    fontFamily: 'Roboto'))),
                        Align(
                            alignment: Alignment(-1, 0.125),
                            child: Text('So verhalten Sie sich richtig',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: data.size.height / 51,
                                    fontFamily: 'Roboto'))),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.question_answer_rounded,
                              color: Colors.green, size: data.size.height / 12),
                        ),
                      ]),
                      onPressed: () {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Page2()));
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                    width: data.size.width,
                    height: data.size.height / 8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white.withOpacity(0.3),
                      textColor: Colors.black,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment(-1, -0.5),
                            child: Text('To Do List',
                                style: TextStyle(
                                    fontSize: data.size.height / 35,
                                    fontFamily: 'Roboto'))),
                        Align(
                            alignment: Alignment(-1, 0.125),
                            child: Text('In der häuslichen Quarantäne',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: data.size.height / 51,
                                    fontFamily: 'Roboto'))),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconLinearGradientMask(
                            child: Icon(
                              Icons.coronavirus_rounded,
                              size: data.size.height / 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                      onPressed: () {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Page3()));
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                    width: data.size.width,
                    height: data.size.height / 8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white.withOpacity(0.3),
                      textColor: Colors.black,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment(-1, -0.5),
                            child: Text('Globale Statistik',
                                style: TextStyle(
                                    fontSize: data.size.height / 35,
                                    fontFamily: 'Roboto'))),
                        Align(
                            alignment: Alignment(-1.0, 0.45),
                            child: Text(
                                'Länder Fallzahlen weltweit als \nKarte angezeigt',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: data.size.height / 51,
                                    fontFamily: 'Roboto'))),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.public,
                            size: data.size.height / 12,
                            color: Color(0xff2253d1),
                          ),
                        ),
                      ]),
                      onPressed: () {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Page6()));
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                      width: data.size.width,
                      height: data.size.height / 8,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        color: Colors.white.withOpacity(0.3),
                        textColor: Colors.black,
                        child: Stack(children: <Widget>[
                          Align(
                              alignment: Alignment(-1, -0.5),
                              child: Text('Fallzahlendiagramm',
                                  style: TextStyle(
                                      fontSize: data.size.height / 35,
                                      fontFamily: 'Roboto'))),
                          Align(
                              alignment: Alignment(-1, 0.45),
                              child: Text(
                                  'Erstellen Sie ein Diagramm zur \nVeranschaulichung der Fallzahlen',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: data.size.height / 51,
                                      fontFamily: 'Roboto'))),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.bar_chart_rounded,
                                size: data.size.height / 12,
                                color: Colors.deepOrange,
                              )),
                        ]),
                        onPressed: () {
                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Page4_1()));
                        },
                      )),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                    width: data.size.width,
                    height: data.size.height / 8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white.withOpacity(0.3),
                      textColor: Colors.black,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment(-1, -0.4),
                            child: Text('Symptome für Covid-19',
                                style: TextStyle(
                                    fontSize: data.size.height / 35,
                                    fontFamily: 'Roboto'))),
                        Align(
                            alignment: Alignment(-1, 0.5),
                            child: Text(
                                'Häufige Symptome zur \nCovid-Erkrankung',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: data.size.height / 51,
                                    fontFamily: 'Roboto'))),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.sick_rounded,
                            size: data.size.height / 12,
                            color: Color(0xff64B249),
                          ),
                        ),
                      ]),
                      onPressed: () {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Page5()));
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                    width: data.size.width,
                    height: data.size.height / 8,
                    child: homepagepdf(context),
                  ),
                ),
              ],
              //  ),
              // ],
            ),
          ],
        ),
      ),
    );
  }

  // liegt hier vielleicht der Fehler ?
  @override
  void dispose() {
    super.dispose();
    //_streamSubscription.cancel();
  }

  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }
}