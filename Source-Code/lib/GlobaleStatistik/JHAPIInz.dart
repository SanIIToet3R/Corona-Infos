/* NOT USED ---> ask Julia
import 'dart:developer' as developer;
import '../API/tools.dart';
import 'LaenderMap.dart';

DateTime zeroOutDate(DateTime dt){
  return DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0,0);
}
DateTime getDateToday(){
  DateTime timeToday = DateTime.now();
  return zeroOutDate(timeToday);
}
DateTime getDateADayBefore(DateTime dt){
  return dt.subtract(Duration(days: 1));
}
DateTime getDateOneWeekFrom(DateTime dt){
  dt = dt.subtract(Duration(days: 7));
  return dt;
}
String _makeURLCallForDay(String countrySlug, DateTime toDt){

  return 'https://api.covid19api.com/country/$countrySlug/status/confirmed?from=${getDateADayBefore(toDt).toIso8601String()}&to=${toDt.toIso8601String()}';
}
class Holder{
  static int delay = 0;
}
Future getTotalCasesFor(String slug)async{
  await Future.delayed(Duration(seconds: Holder.delay++ % 5));
  const KEY_CASES = 'Cases';
  List<dynamic> dataToday;
  DateTime dateToday = getDateToday();
  try{
    dataToday = await jsonRequest(_makeURLCallForDay(slug, dateToday));
    developer.log(dataToday.toString());
    if(dataToday.length == 0)
      return 99;
    return dataToday[0][KEY_CASES];

  }
  catch(e){
    developer.log("ERROR:-- ", error: e);
    return -1;
  }
}
Future getIncidenceFor(String slug) async{
  await Future.delayed(Duration(seconds: Holder.delay++ % 10));
  const KEY_CASES = 'Cases';
  List<dynamic> dataToday;
  List<dynamic> dataOneWeekAgo;
  DateTime dateToday = getDateToday();
  DateTime dateOneWeekAgo = getDateOneWeekFrom(dateToday);
  developer.log(_makeURLCallForDay(slug, dateToday));
  developer.log(_makeURLCallForDay(slug, dateOneWeekAgo));
  try{
    dataToday = await jsonRequest(_makeURLCallForDay(slug, dateToday));
    dataOneWeekAgo = await jsonRequest(_makeURLCallForDay(slug, dateOneWeekAgo));
  }
  catch(e){
    developer.log("ApiError", error: e);
    return 0;
  }

  try{
    int casesToday = dataToday[0][KEY_CASES];
    int casesOneWeekAgo = dataOneWeekAgo[0][KEY_CASES];
    return ((casesToday.toDouble()-casesOneWeekAgo.toDouble()) / (Laender[slug][K_LAENDER_POPUL])*100000);
  }catch(RangeError){
    return 1;
  }
}
*/