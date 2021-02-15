/*
 * Hilfsobjekt, durch welches der Name es aktuellen Landkreises aus den Daten der Datenbank,
 * welche als Map vorliegen, extrahiert werden kann.
 */
class DataForHomeScreen{
  final String lkName;

  DataForHomeScreen({this.lkName});

  factory DataForHomeScreen.fromDB(Map<String, dynamic> data){
    return DataForHomeScreen(
    lkName: data['county']
    );
  }
}