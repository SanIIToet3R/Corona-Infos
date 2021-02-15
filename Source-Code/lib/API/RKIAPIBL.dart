import 'dart:async';
import 'tools.dart';


Future<List<Bundesland>> fetchBundesland() async {
  List<Bundesland> bl_list = [];
  dynamic data = await jsonRequest('https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/Coronaf%C3%A4lle_in_den_Bundesl%C3%A4ndern/FeatureServer/0/query?where=1%3D1&outFields=LAN_ew_GEN,LAN_ew_EWZ,OBJECTID,Fallzahl,Aktualisierung,Death,cases7_bl_per_100k&returnGeometry=false&outSR=4326&f=json');
  if(data == null) return null;
  List body = data['features'];
    for(int i = 0; i<body.length; i++){
      bl_list.add(Bundesland.fromJson(body[i]['attributes']));
    }
    return bl_list;
}

class Bundesland {
  final String LAN_ew_GEN;
  final int LAN_ew_EWZ;
  final int OBJECTID;
  final int Fallzahl;
  final int Aktualisierung;
  final double cases7_bl_per_100k;
  final int Death;

  Bundesland(
      {this.LAN_ew_GEN, this.LAN_ew_EWZ, this.OBJECTID, this.Fallzahl, this.Aktualisierung, this.cases7_bl_per_100k, this.Death});

  factory Bundesland.fromJson(Map<String, dynamic> json){
    return Bundesland(
      LAN_ew_GEN: json['LAN_ew_GEN'],
      LAN_ew_EWZ: json['LAN_ew_EWZ'],
      OBJECTID: json['OBJECTID'],
      Fallzahl: json['Fallzahl'],
      Aktualisierung: json['Aktualisierung'],
      cases7_bl_per_100k: json['cases7_bl_per_100k'],
      Death: json['Death'],
    );
  }
}