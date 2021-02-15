import 'package:flutter/material.dart';
import 'package:flutter_app/API/JHAPIWelt.dart';
import 'package:flutter_app/API/RKIAPIBL.dart';
import 'API/RKIAPILK.dart';
import 'Logik/Datenabfrage_bl.dart';
import 'Logik/Datenabfrage_lk.dart';
import 'fallzahlendiagramm.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/API/tools.dart' as tools;

class Page4_1 extends StatefulWidget {
  Page4_1({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Page4_1State createState() => _Page4_1State();
}

class _Page4_1State extends State<Page4_1> {
  List<Landkreis> lkListToPass;
  List<Bundesland> blListToPass;

  //Dropdown Bundeslaender
  String dropdownValue;
  List listItem = [
    'Baden-Württemberg',
    'Bayern',
    'Berlin',
    'Brandenburg',
    'Bremen',
    'Hamburg',
    'Hessen',
    'Mecklenburg-Vorpommern',
    'Niedersachsen',
    'Nordrhein-Westfalen',
    'Rheinland-Pfalz',
    'Saarland',
    'Sachsen',
    'Sachsen-Anhalt',
    'Schleswig-Holstein',
    'Thüringen',
  ];

  //Dropdown Sortierweise
  String dropdownValue2 = "A bis Z";
  List listItem2 = [
    'Aufsteigend',
    'Absteigend',
    'A bis Z',
  ];

    /*
   * ruft die Bundeslanddaten ab und fuellt sie in das Attribut bl_list innerhalb des Objekts
   */
  void getDataForBundeslandDaten(int sortByID) async {
    print("Start Request...");
    Datenabfrage_bl bl_abfrage = new Datenabfrage_bl();
    await bl_abfrage.requestBundeslandData(sortByID, context);
    print("Request complete");
    this.blListToPass = bl_abfrage.bl_list;
  }

  /*
   * ruft die Landkreisdaten ab und fuellt sie in das Attribut lk_list innerhalb des Objekts
   */
  void getDataForLandkreisDaten(String bundesland, int sortById) async {
    print("Start Request...");
    Datenabfrage_lk lk_abfrage = new Datenabfrage_lk();
    await lk_abfrage.requestLandkreisData(bundesland, sortById, context);
    print("Request complete");
    this.lkListToPass = lk_abfrage.lk_list;
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Banner Oben rechts
      home: Scaffold(
        body: Stack(children: <Widget>[
          Container(
              color: Color(0xFF90ee90)
          ),
          ListView(//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              // margin vom Container
              width: data.size.width,
              height: data.size.height - 45,
              // höhe des Container - der margin
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: const BorderRadius.all(const Radius.circular(6)),
              ),
              child: Stack(children: <Widget>[
                Align(
                  alignment: Alignment(-1.0, -1.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.black, size: data.size.height / 24),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                    alignment: Alignment(0.1, -0.97),
                    child: Text('Fallzahlendiagramm erstellen',
                        style: TextStyle(
                            fontSize: data.size.width / 23,
                            fontFamily: 'Roboto'))),
                Align(
                    alignment: Alignment(0.1, -0.77),
                    child: Text('Fallzahlen deutschlandweit',
                        style: TextStyle(
                            fontSize: data.size.height / 35,
                            fontFamily: 'Roboto'))),
                Align(
                  //Button 1
                  alignment: Alignment(0.0, -0.63),
                  child: SizedBox(
                    width: 280.0,
                    height: data.size.height / 17,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white.withOpacity(0.3),
                      textColor: Colors.black,
                      //elevation: 3.0,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Diagramm erstellen',
                                style: TextStyle(
                                    fontSize: data.size.height / 35,
                                    fontFamily: 'Roboto'))),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.bar_chart_rounded,
                              size: data.size.height / 35),
                        ),
                      ]),
                      onPressed: () async {
                        int sortType;
                        if (dropdownValue2 == "A bis Z") {
                          sortType = 2;
                        } else if (dropdownValue2 == "Aufsteigend") {
                          sortType = 1;
                        } else {
                          sortType = 0;
                        }
                        await getDataForBundeslandDaten(sortType);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FallzahlenDiagrammScreen(
                                    null, this.blListToPass)));
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ]);
                      },
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0.0, -0.4),
                    child: Container(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('Fallzahlen im Bundesland',
                          style: TextStyle(
                              fontSize: data.size.height / 35,
                              fontFamily: 'Roboto')),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                          color: Colors.black,
                        )),
                      ),
                    )),
                Align(
                  alignment: Alignment(0.0, -0.265), //DropDown
                  child: Padding(
                    padding: const EdgeInsets.all(46.0),
                    // "Breite" einstellen
                    child: Container(
                      height: data.size.height / 20,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      // padding für den Text&Icon im DropDownMenu
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton(
                        hint: Text("Bundesland"),
                        dropdownColor: Colors.grey[350],
                        icon: Icon(Icons.arrow_drop_down_outlined,
                            color: Colors.black),
                        iconSize: data.size.height / 18,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: data.size.height / 35,
                          fontFamily: 'Roboto',
                        ),
                        value: dropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, -0.05), //Button 2
                  child: SizedBox(
                    width: 280.0,
                    height: data.size.height / 17,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white.withOpacity(0.3),
                      textColor: Colors.black,
                      //elevation: 3.0,
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Diagramm erstellen',
                                style: TextStyle(
                                    fontSize: data.size.height / 35,
                                    fontFamily: 'Roboto'))),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.bar_chart_rounded,
                              size: data.size.height / 35),
                        ),
                      ]),
                      onPressed: () async {
                        print("Auswahl wird durchgefuehrt...");
                        int sortType;
                        String bundesLand =
                            dropdownValue;
                        if (dropdownValue2 == "A bis Z") {
                          sortType = 2;
                        } else if (dropdownValue2 == "Aufsteigend") {
                          sortType = 1;
                        } else {
                          sortType = 0;
                        }
                        if(bundesLand == null){
                          tools.showAlertDialog(
                            title: 'Fehlende Auswahl',
                            content: 'Bitte wählen Sie ein Bundesland aus.',
                            context: context);
                        }else {
                          await getDataForLandkreisDaten(bundesLand, sortType);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FallzahlenDiagrammScreen(
                                          this.lkListToPass,
                                          null)));
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                        }
                      },
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0.0, 0.2),
                    child: Container(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('Diagramm sortieren nach...',
                          style: TextStyle(
                              fontSize: data.size.height / 35,
                              fontFamily: 'Roboto')),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                          color: Colors.black,
                        )),
                      ),
                    )),
                Align(
                  alignment: Alignment(0.0, 0.375), //DropDown 2
                  child: Padding(
                    padding: const EdgeInsets.all(46.0),
                    // "Breite" einstellen
                    child: Container(
                      height: data.size.height / 20,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      // padding für den Text&Icon im DropDownMenu
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton(
                        dropdownColor: Colors.grey[350],
                        icon: Icon(Icons.arrow_drop_down_outlined,
                            color: Colors.black),
                        iconSize: data.size.height / 18,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: data.size.height / 35,
                          fontFamily: 'Roboto',
                        ),
                        value: dropdownValue2,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue2 = newValue;
                          });
                        },
                        items: listItem2.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0.1, 0.95),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                      child: Text(
                          'Im oberen Abschnitt kann man sich ein Diagramm für ganz Deutschland (alle Bundesländer aufgelistet) anzeigen lassen. \n\nIm mittleren Abschnitt kann man ein Bundesland auswählen, sodass man ein Diagramm mit dem Landkreisen in diesem Bundesland angezeigt bekommt.\n\nIm letzten Abschnitt kann man das Diagramm entsprechend sortieren',
                          style: TextStyle(
                              fontSize: data.size.width / 32,
                              color: Color(0xFF3F3F3F),
                              fontFamily: 'Roboto')),
                    )),
              ]),
            ),
          ]),
        ]),
      ),
    );
  }
}
