import 'dart:async';
import 'tools.dart';

Future<List<Landkreis>> fetchLandkreise() async {
  List<Landkreis> lk_list = [];
  dynamic data = await jsonRequest('https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=1%3D1&outFields=OBJECTID,GEN,BEZ,EWZ,cases,deaths,cases_per_population,cases7_per_100k,BL,BL_ID,last_update,recovered&outSR=4326&f=json');
  if(data == null) return null;
  List body = data['features'];
    for(int i = 0; i<body.length; i++){
      lk_list.add(Landkreis.fromJson(body[i]['attributes']));
    }
    return lk_list;
}

class Landkreis {
  final int OBJECTID;
  final String GEN;
  final int EWZ;
  final int cases;
  final String BEZ;
  final int deaths;
  final double cases_per_population;
  final String BL;
  final String BL_ID;
  final String last_update;
  final double cases7_per_100k;
  final int recovered;


  Landkreis({this.OBJECTID, this.GEN, this.BEZ, this.EWZ, this.cases, this.deaths, this.cases_per_population, this.BL, this.BL_ID, this.last_update, this.cases7_per_100k, this.recovered});
  factory Landkreis.fromJson(Map<String, dynamic> json){
    return Landkreis(
        OBJECTID: json['OBJECTID'],
        GEN: json['GEN'],
        BEZ: json['BEZ'],
        EWZ: json['EWZ'],
        cases: json['cases'],
        deaths: json['deaths'],
        cases_per_population: json['cases_per_population'],
        BL: json['BL'],
        BL_ID: json['BL_ID'],
        last_update: json['last_update'],
        cases7_per_100k: json['cases7_per_100k'],
        recovered: json['recovered']
    );
  }
}