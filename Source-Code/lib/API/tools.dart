import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'dart:developer' as dev;
import 'package:flutter_app/main.dart';

void showAlertDialog({BuildContext context, String title, String content}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
      ));
}

const K_APIEXCEPTION_TIMEOUT = 24601;
class APIException implements Exception {
  int statusCode;
  String statusString;
  String statusBeschreibung;
  APIException(int statusCode){
    this.statusCode = statusCode;
    if(statusCode >= 300 && statusCode < 400) {
      statusString = "Umleitungsfehler";
      statusBeschreibung =  "Die API-Adresse wurde umgeleitet.";
    }
    else if (statusCode >= 400 && statusCode < 500) {
      statusString = "Client-Fehler";
      statusBeschreibung = "Es ist seitens des Client etwas schief gelaufen. Bitte versuchen Sie es später noch einmal. Wir versuchen, uns schnellstmöglich um das Problem zu kümmern.";
    }
    if (statusCode == K_APIEXCEPTION_TIMEOUT){
      statusString = "Langsames Internet";
      statusBeschreibung= "Sie haben eine langsame Internetverbindung. Bitte versuchen Sie es später nochmal.";
    }
    else {
      statusString = "Server-Fehler";
      statusBeschreibung = "Etwas ist seitens Dritter schief gelaufen. Bitte versuchen Sie es später noch einmal.";
    }
  }
}

Future<dynamic> mitAPIFehlebehandlung ({dynamic apifunktion, BuildContext context})async{
  try {
     return await apifunktion();
  } on APIException catch (e) {
    showAlertDialog(
        title: e.statusString,
        content: e.statusBeschreibung,
        context: context);
  } on io.SocketException {
    showAlertDialog(
        title: "Kein Internet",
        content:
        "Sie haben keine Internetverbindung. Bitte versuchen Sie es später nochmal oder schalten Sie ihr Internet ein.",
        context: context);
  } catch (e) {
    showAlertDialog(
        title: "Unbekannter Fehler",
        content:
        "Es tut uns sehr leid, ein unbekannter Fehler ist aufgetreten.",
        context: context);
    dev.log("Ubekannter Fehler: $e", error: e);
  }
  return null;
}

Future<dynamic> jsonRequest(String url) async{
  //dev.log("${DateTime.now()}: jsonRequest($url)");
  try {
    final response = await http.get(url).timeout(Duration(seconds: 10), onTimeout: () => throw new APIException(K_APIEXCEPTION_TIMEOUT));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }else{
      dev.log("Throwing Api Exception: ${response.statusCode}");
      throw APIException(response.statusCode);

    }
  } on io.SocketException catch (e) {
    throw e;
  }
  }