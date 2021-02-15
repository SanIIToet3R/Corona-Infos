import 'dart:io' as io;
import 'package:flutter_app/API/tools.dart' as APItools;
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_app/API/JHAPIWelt.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app/GlobaleStatistik/LaenderMap.dart' as g;

class Page6 extends StatefulWidget {
  @override
  Page6State createState() => Page6State();
}

class Page6State extends State<Page6> {
  Set<Marker> _markers = {};

/*
Not USED; For incidence on each marker
void _onMarkerTapped(Marker marker) async{
  print("ABC123 - ONTAP entered");
  var i = await getIncidenceFor(marker.markerId.toString());
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text("[${marker.markerId.toString()}] Inzidenz: $i"),
  ));
  print("ABC123 - ONTAP exited");
}

 */
  void _onMapCreated(GoogleMapController controller, BuildContext context) async {
    List<Land> laenderCases = await APItools.mitAPIFehlebehandlung(
        apifunktion: fetchLaender,
        context: context);

    if(laenderCases == null) return;

    laenderCases.forEach((element) {
      try {
        g.Laender[element.Slug]['cases'] = element.TotalConfirmed;
      } catch (e) {
        dev.log("Das Land ${element.Slug} ist nicht in der LaenderMap, hat aber Fallzahlen. (_onMapCreated)");
      }
    });

    setState(() {
      for (var slug in g.Laender.keys) {
        if(g.Laender[slug]['lat'] == null || g.Laender[slug]['lng'] == null || g.Laender[slug]['name']== null){
          /*
            Skip any Leander with broken entries in LeanderMap
           */
          continue;
        }

        //dev.log("Add Marker for : $slug");
        var markericon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
        int totalCases = g.Laender[slug][g.K_LAENDER_CASES];
        double casesPerCapita = 0.0;
        double alpha = 0.5;
        /*
        Total Cases might be null if no data for a given Country is retrieved
        Then the marker has the defaults: alpha=0.5; color=green;
       */
        if (totalCases != null) {
          alpha = 1.0;
          casesPerCapita =
              totalCases.toDouble() / g.Laender[slug][g.K_LAENDER_POPUL];
          //dev.log('$slug: $casesPerCapita');
          if (casesPerCapita <= 0.02) {
            markericon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen);
          } else if (casesPerCapita <= 0.05) {
            markericon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow);
          } else if (casesPerCapita <= 0.10) {
            markericon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange);
          } else {
            markericon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          }
        }
        String infoText =
            'Fälle insgesamt: ${totalCases == null ? 'Keine Daten verfügbar' : totalCases} (${(casesPerCapita * 100).toStringAsFixed(2)} % der Bevölkerung)';
        //dev.log("Adding Marker: $slug");
        _markers.add(Marker(
          alpha: alpha,
          markerId: MarkerId(slug),
          position: LatLng(g.Laender[slug]['lat'], g.Laender[slug]['lng']),
          /*consumeTapEvents: false,
              onTap: () {
              _onMarkerTapped(slug);
            }, */
          infoWindow: InfoWindow(
            title: g.Laender[slug]['name'],
            snippet: infoText,
          ),
          icon: markericon,
        ));
      }
    });
  }

   @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context); //Endgerät daten z.b größe
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Banner Oben rechts
      home: Scaffold(
        body: Stack(children: [
          Container(
              color: Color(0xFF90ee90)
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 35, 10, 10),
            height: data.size.height,
            width: data.size.width,
            decoration: BoxDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(06),
                topRight: Radius.circular(06),
                bottomRight: Radius.circular(06),
                bottomLeft: Radius.circular(06),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(48.483334, 9.216667),
                  zoom: 4,
                ),
                onMapCreated: (controller) =>
                    _onMapCreated(controller, context),
                markers: _markers,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.7, -0.91),
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.black, size: data.size.height / 24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment(-0.85, 0.87),
            child: Container(
              // margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              width: data.size.height / 4.5,
              height: data.size.height / 3.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: const BorderRadius.all(const Radius.circular(6)),
              ),
              child: Stack(children: <Widget>[
                Align(
                    alignment: Alignment(-0.55, -0.925),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      width: 150,
                      child: Text("Legende",
                          style: TextStyle(
                              fontSize: data.size.height / 37,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto')),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.black,
                        )),
                      ),
                    )),
                Align(
                    alignment: Alignment(-1, -0.55),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Colors.green,
                      size: data.size.height / 25,
                    )),
                Align(
                    alignment: Alignment(0.4, -0.55),
                    child: Text("Fallzahlen <= 2%",
                        style: TextStyle(
                            fontSize: data.size.height / 50,
                            fontFamily: 'Roboto'))),
                Align(
                    alignment: Alignment(-1, -0.15),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Colors.yellow,
                      size: data.size.height / 25,
                    )),
                Align(
                    alignment: Alignment(0.4, -0.15),
                    child: Text("Fallzahlen <= 5%",
                        style: TextStyle(
                            fontSize: data.size.height / 50,
                            fontFamily: 'Roboto'))),
                Align(
                    alignment: Alignment(-1, 0.25),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Colors.orange,
                      size: data.size.height / 25,
                    )),
                Align(
                    alignment: Alignment(0.6, 0.225),
                    child: Text("Fallzahlen <= 10%",
                        style: TextStyle(
                            fontSize: data.size.height / 50,
                            fontFamily: 'Roboto'))),
                Align(
                    alignment: Alignment(-1, 0.65),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                      size: data.size.height / 25,
                    )),
                Align(
                    alignment: Alignment(0.4, 0.60),
                    child: Text("Fallzahlen > 10%",
                        style: TextStyle(
                            fontSize: data.size.height / 50,
                            fontFamily: 'Roboto'))),
                Align(
                    alignment: Alignment(-0.9, 0.95),
                    child: Text(
                        "Provided by Johns Hopkins University \nCenter for Systems Science \nand Engineering (JHU CSSE)",
                        style: TextStyle(
                            fontSize: data.size.height / 95,
                            fontFamily: 'Roboto'))),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
