/*
 * Hilfsobjekt, um die Daten der Landkreise oder Bundeslaender in einem einheitlichen Format
 * fuer die Grapherstellung bereit zu stellen.
 */
class DataForChart{

  int objectID;
  String name;
  double inzidenz;

  DataForChart(int objectId, String name, double inzidenz){
    this.objectID = objectId;
    this.name = name;
    this.inzidenz = inzidenz;
  }

}