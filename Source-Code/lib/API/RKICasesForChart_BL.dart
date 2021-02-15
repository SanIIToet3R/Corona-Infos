import 'dart:async';
import 'tools.dart';

Future<List<BundeslandCases>> fetchBundeslandForChart() async{
  List<BundeslandCases> cases_list = [];
  dynamic data = await jsonRequest('https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/Coronaf%C3%A4lle_in_den_Bundesl%C3%A4ndern/FeatureServer/0/query?where=1%3D1&outFields=OBJECTID,Fallzahl&returnGeometry=false&outSR=4326&f=json');
  List body = data['features'];
  for(int i = 0 ; i < body.length; i++){
    cases_list.add(BundeslandCases.fromJson(body[i]['properties']));
  }
  return cases_list;

}


class BundeslandCases {
  final int Fallzahl;
  final int OBJECTID;

  BundeslandCases({this.Fallzahl, this.OBJECTID});
  factory BundeslandCases.fromJson(Map<String, dynamic> json){
    return BundeslandCases(
      OBJECTID: json['OBJECTID'],
      Fallzahl: json['Fallzahl']
    );

  }
}