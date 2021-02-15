import 'package:flutter/material.dart';
import 'package:flutter_app/API/JHAPIWelt.dart';
import 'package:flutter_app/API/RKIAPILK.dart';
import 'package:flutter_app/API/tools.dart' as tools;

class Datenabfrage_lk{

  List<Landkreis> lk_list ;

  /*
   * Fragt ueber die API-Schnittstelle die aktuellen Landkreisdaten ab und passt die Daten an
   * parameter: bundesLandName --> Name des gewaehlten Bundeslandes
   *            sortbyID --> ID der Sortierweise: 0-absteigend; 1-aufsteigend; 2-alphabetisch a-z
   */
  Future<void> requestLandkreisData(String bundesLandName, int sortbyID, BuildContext context) async{
    this.lk_list = await tools.mitAPIFehlebehandlung(apifunktion: fetchLandkreise, context: context);
    _selectNeededLandkreise(bundesLandName);
    _sort(sortbyID);
  }

  /*
   * Sortiert die Elemente der Liste in Abhaengigkeit des uebergebenen Parameters
   */
  void _sort(int sortby){
    switch(sortby){
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
   * Aktualisiert die Liste mit allen Landkreisdaten so, dass nur die Landkreise
   * des uebergebenen Bundeslandes in der Liste verbleiben
   */
  void _selectNeededLandkreise(String BndLndName) {
    List<Landkreis> specificList = new List<Landkreis>();
    int max = this.lk_list.length;
    for(int i = 0; i < max; i++){
      if(this.lk_list.elementAt(i).BL == BndLndName){
        if(this.lk_list.elementAt(i).BEZ == "Landkreis" || this.lk_list.elementAt(i).BEZ == "Kreis" || this.lk_list.elementAt(i).BEZ == "Bezirk"
            ||  this.lk_list.elementAt(i).OBJECTID == 62 ||  this.lk_list.elementAt(i).OBJECTID == 16) {  // 62 = Bremen und 16 = Hamburg) {
          specificList.add(this.lk_list.elementAt(i));
        }
      }
    }
    this.lk_list = specificList;
  }

  /*
   * Sortiert die bl_List nach Inzidenz absteigend
   */
  void _normalSort(){
    lk_list.sort((a, b) => a.cases7_per_100k.compareTo(b.cases7_per_100k));
    lk_list.forEach((BundeslandCases) => print(BundeslandCases.cases7_per_100k));
  }

  /*
   * Sortiert die bl_List nach Inzidenz aufsteigend
   */
  void _reverseSort(){
    lk_list.sort((b, a) => a.cases7_per_100k.compareTo(b.cases7_per_100k));
    lk_list.forEach((BundeslandCases) => print(BundeslandCases.cases));
  }

  /*
   * Sortiert die bl_List nach Alphabet aufsteigend (A - Z)
   */
  void _alphabeticalSort(){
    lk_list.sort((a, b) => b.GEN.compareTo(a.GEN));
    lk_list.forEach((Landkreisnamen) => print(Landkreisnamen.GEN));
  }

  /*
   * Gibt die Landkreisdaten eines Landkreises zurueck, dessen Name der Methode uebergeben wird
   * !ACHTUNG! Kann ein null-Objekt zurueckgeben, falls der Landkreis in den vorhandenen Daten nicht gefunden werden kann
   */
  Future<Landkreis> selectLKforHomescreen(String positionLandkreis, BuildContext context) async{
    print("Getting Information from current position...");
    Landkreis returnLK = null;
    List<Landkreis> lkListe = await tools.mitAPIFehlebehandlung(apifunktion: fetchLandkreise, context: context);
    print("LK-List-request complete. Select needed LK...");
    int length = lkListe.length;
    Landkreis currentLk = null;
    for(int i = 0 ; i < length ; i++) {
      currentLk = lkListe.elementAt(i);
      if (lkListe.elementAt(i).GEN == positionLandkreis) {
        if(lkListe.elementAt(i).BEZ == "Landkreis" || lkListe.elementAt(i).BEZ == "Kreis" || lkListe.elementAt(i).BEZ == "Bezirk"
            || lkListe.elementAt(i).OBJECTID == 62 || lkListe.elementAt(i).OBJECTID == 16) {  // 62 = Bremen und 16 = Hamburg
          returnLK = currentLk;
          print("found fitting dataset");
          break;
        }
      }
    }
    return returnLK;
  }
}