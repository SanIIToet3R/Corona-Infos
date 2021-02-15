import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/API/RKIAPIBL.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/API/tools.dart' as tools;


class Datenabfrage_bl {

  List<Bundesland> bl_list;

  /*
   * Sortiert die Elemente der Liste in Abhaengigkeit des uebergebenen Parameters
   */
  void _sort(int sort_type){
    switch(sort_type){
      case 0:{
        _normalSort();
      }break;
      case 1:{
        _reverseSort();
      }break;
      case 2:{
        _alphabeticalSort();
      }break;
    }
  }

  /*
   * Fragt ueber die API-Schnittstelle die aktuellen Bundeslanddaten ab und passt die Daten an
   * parameter: sortbyID --> ID der Sortierweise: 0-absteigend; 1-aufsteigend; 2-alphabetisch a-z
   */
  Future<void> requestBundeslandData(int sort_by_id, BuildContext context) async{
    this.bl_list = await tools.mitAPIFehlebehandlung(apifunktion: fetchBundesland, context: context);
    this._sort(sort_by_id);
  }

  /*
   * Sortiert die bl_List nach Sortiert die bl_List nach Inzidenz absteigend
   */
  void _normalSort(){
    bl_list.sort((a,b) => a.cases7_bl_per_100k.compareTo(b.cases7_bl_per_100k));
    bl_list.forEach((Bundesland) => print(Bundesland.cases7_bl_per_100k));
  }

  /*
   * Sortiert die bl_List nach Inzidenz aufsteigend
   */
  void _reverseSort(){
    bl_list.sort((b, a) => a.cases7_bl_per_100k.compareTo(b.cases7_bl_per_100k));
    bl_list.forEach((Bundesland) => print(Bundesland.cases7_bl_per_100k));
  }

  /*
   * Sortiert die bl_List nach Alphabet aufsteigend (A - Z)
   */
  void _alphabeticalSort(){
    bl_list.sort((a, b) => b.LAN_ew_GEN.compareTo(a.LAN_ew_GEN));
    bl_list.forEach((BundeslandNamen) => print(BundeslandNamen.LAN_ew_GEN));
  }

}