import 'dart:async';

import 'tools.dart';
import 'JHAPIWelt.dart';

Future<Land> fetchDeutschland() async {   //Versprechen, dass List mit CasesPerDay zurückgegeben wird
  dynamic data = await jsonRequest('https://api.covid19api.com/summary');
  if(data == null) return null;
    List body = data["Countries"]; //Liste Body
    for(int i = 0; i<body.length; i++){
      var element = body[i];
      if(element["Country"] == "Germany") {
        return Land.fromJson(element);
      }
    }
    throw Exception('Germany was not found in fetchDeutschland');
}
