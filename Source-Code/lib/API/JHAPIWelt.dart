import 'dart:async';
import 'tools.dart';

Future<List<Land>> fetchLaender() async {   //Versprechen, dass List mit CasesPerDay zurückgegeben wird
 dynamic data = await jsonRequest('https://api.covid19api.com/summary');
 //new
 if(data == null) return null;
 List<Land> land_list = [];
    List body = data["Countries"]; //Liste Body
    for(int i = 0; i<body.length; i++){
      land_list.add(Land.fromJson(body[i]));
      }
    return land_list;
}

class Land {
  final String Country;
  final String CountryCode;
  final String Slug;
  final int NewConfirmed;
  final int TotalConfirmed;
  final int NewDeaths;
  final int TotalDeaths;
  final int NewRecovered;
  final int TotalRecovered;
  final String Date;

  Land({this.Country, this.CountryCode, this.Slug, this.NewConfirmed, this.TotalConfirmed, this.NewDeaths, this.TotalDeaths, this.NewRecovered, this.TotalRecovered, this.Date}); //Constructor
  factory Land.fromJson(Map<String, dynamic> json){  //erzeugt CasesPerDay Objekte
    return Land(
        Country: json['Country'],
        CountryCode: json['CountryCode'],
        Slug: json['Slug'],
        NewConfirmed: json['NewConfirmed'],
        TotalConfirmed: json['TotalConfirmed'],
        NewDeaths: json['NewDeaths'],
        TotalDeaths: json['TotalDeaths'],
        NewRecovered: json['NewRecovered'],
        TotalRecovered: json['TotalRecovered'],
        Date: json['Date']
    );
  }
}