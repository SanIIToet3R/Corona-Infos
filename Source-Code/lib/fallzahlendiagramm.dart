import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:flutter_app/API/RKIAPILK.dart';
import 'package:flutter_app/API/tools.dart';
import 'package:flutter_app/Logik/DataForChart.dart';

import 'API/RKIAPIBL.dart';

double AnzLK; // für Scrollbares Fallzahldiagramm

class FallzahlenDiagrammScreen extends StatefulWidget {
  final Widget child;

  List<Bundesland> blList;
  List<Landkreis> lkList;

  /*
   * Erstelle eine Instanz des States fuer diesen Screen mit den uebergebenen Daten
   * und gebe in der Konsole aus, welche Daten verwendet werden
   */
  FallzahlenDiagrammScreen(List<Landkreis> lkListFromSelection, List<Bundesland> blListFromSelection, {Key key, this.child}) : super(key: key){
    this.blList = blListFromSelection;
    this.lkList = lkListFromSelection;
    if(this.blList != null) print("working with Bundeslanddaten");
    else if(this.lkList != null) print("working with Landkreisdaten");
  }

  FallzahlenDiagrammScreenState createState() => FallzahlenDiagrammScreenState(this.blList, this.lkList); //Irgendwo hier liegt der Fehler
}

class FallzahlenDiagrammScreenState extends State<FallzahlenDiagrammScreen> {

  List<Bundesland> blList;
  List<Landkreis> lkList;
  List<DataForChart> dataList;
  List<charts.Series<DataForChart, String>> _seriesData;

  //Kustruktor zum zuweisen der Werte
  FallzahlenDiagrammScreenState(List<Bundesland> blList, List<Landkreis> lkList) {
    this.blList = blList;
    this.lkList = lkList;
  }

  @override
  void initState() {
    super.initState();
    _selectListToShow();
    print("State created. \n Generating charts...");
    _seriesData = List<charts.Series<DataForChart, String>>();
    _generateData();
  }

  /*
   * Diese Methode sorgt dafuer, dass nur die gefuellte Liste verwendet wird, je nach Auswahl nach LK oder BL.
   * Eine der Listen wird immer NULL sein und kann daher nicht verwendet werden.
   * Zusaetzlich schriebt sie die Daten in einem Quellunabhaengigen Format in das Objektattribut "dataList", woraus
   * folglicht das Diagramm erstellt wird
   */
  void _selectListToShow() {
    if (this.blList != null) {
      _mapBlDataForChart();
      return;
    } else if (this.lkList != null) {
      _mapLkDataForChart();
      return;
    } else
      throw new APIException(
          450); //Hier wird die API-Exception verwendet, da diese Fehlermeldung ausreicht
  }

  /*
   * Diese Methode ueberfuehrt die Bundeslanddaten in das einheitliche Format "DataForChart" und speichert sie im Attribut "dataList"
   */
  void _mapBlDataForChart() {
    List<DataForChart> currentData = new List<DataForChart>();
    int length = blList.length;
    Bundesland currentBl;
    for (int i = 0; i < length; i++) {
      currentBl = blList.elementAt(i);
      currentData.add(new DataForChart(currentBl.OBJECTID, currentBl.LAN_ew_GEN,
          currentBl.cases7_bl_per_100k));
    }
    dataList = currentData;
  }

  /*
   * Diese Methode ueberfuehrt die Bundeslanddaten in das einheitliche Format "DataForChart" und speichert sie im Attribut "dataList"
   */
  void _mapLkDataForChart() {
    List<DataForChart> currentData = new List<DataForChart>();
    int length = lkList.length;
    Landkreis currentlk;
    for (int i = 0; i < length; i++) {
      currentlk = lkList.elementAt(i);
      currentData.add(new DataForChart(
          currentlk.OBJECTID, currentlk.GEN, currentlk.cases7_per_100k));
    }
    dataList = currentData;
  }

  //Fuellen des Fallzahlendiagramms mit entsprechenden Daten
  _generateData() {
    int length = dataList.length;
    DataForChart currentlk;
    for (int i = 0; i < length; i++) {
      currentlk = dataList.elementAt(i);
      var data1 = [currentlk];
      if (currentlk.inzidenz < 50) {
        _seriesData.add(
          charts.Series(
            domainFn: (DataForChart currentlk, _) => currentlk.name,
            measureFn: (DataForChart currentlk, _) => currentlk.inzidenz,
            id: '<50',
            data: data1,
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            fillColorFn: (DataForChart pollution, _) =>
                charts.ColorUtil.fromDartColor(Colors.lightGreen),
          ),
        );
      }else if (currentlk.inzidenz >= 50 && currentlk.inzidenz <= 100){
        _seriesData.add(
          charts.Series(
            domainFn: (DataForChart currentlk, _) => currentlk.name,
            measureFn: (DataForChart currentlk, _) => currentlk.inzidenz,
            id: "50-100",
            data: data1,
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            fillColorFn: (DataForChart pollution, _) =>
                charts.ColorUtil.fromDartColor(Colors.orange),
          ),
        );
      }else if (currentlk.inzidenz >= 100 && currentlk.inzidenz <= 200){
        _seriesData.add(
          charts.Series(
            domainFn: (DataForChart currentlk, _) => currentlk.name,
            measureFn: (DataForChart currentlk, _) => currentlk.inzidenz,
            id: '100-200',
            data: data1,
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            fillColorFn: (DataForChart pollution, _) =>
                charts.ColorUtil.fromDartColor(Colors.red),
          ),
        );
      }else {
        _seriesData.add(
          charts.Series(
            domainFn: (DataForChart currentlk, _) => currentlk.name,
            measureFn: (DataForChart currentlk, _) => currentlk.inzidenz,
            id: '> 200',
            data: data1,
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            fillColorFn: (DataForChart pollution, _) =>
                charts.ColorUtil.fromDartColor(Color(0xff8B0000)),
          ),
        );
      }
      if(length > 50){ // abfrag für scrollen
        AnzLK = 2000;
      }else if(length >= 30 && length < 50){
        AnzLK = 1000;
      }else if(length >= 15 && length < 30){
        AnzLK = 700;
      }else {
    AnzLK = 300;
    }
      }
  }

    Future<bool> _onBackPressed() {
      Navigator.pop(context);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    @override
    Widget build(BuildContext context) {
      final data = MediaQuery.of(context);
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          // debugShowCheckedModeBanner: false,
          body: Stack(
            children: <Widget>[
              Container(
                  color: Color(0xFF90ee90)
              ),
              Container(
                //grau durchsichtiger großer container
                margin: EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0, top: 15.0),
                color: Colors.grey.withOpacity(0.5),
                height: 400.0,
                width: 700.0,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(//Scrollbare Ansicht des Balkendiagramms
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: AnzLK,
                     // child: Column(
                        //children: <Widget>[
                          //Expanded(
                            child: charts.BarChart(
                              _seriesData,
                              animate: true,
                              vertical: false, // Horizontal bar chart
                             // behaviors: [new charts.SeriesLegend()],
                              animationDuration: Duration(seconds: 1), // Balken Dicke
                              defaultRenderer: new charts.BarRendererConfig(
                                groupingType: charts.BarGroupingType.groupedStacked,
                                weightPattern: [2, 1],),
                            ),
                         ),
                       // ],
                     // ),
                    //),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.95, -0.9),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Colors.black, size: data.size.width / 24),
                  onPressed: () {
                    Navigator.pop(context);
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

