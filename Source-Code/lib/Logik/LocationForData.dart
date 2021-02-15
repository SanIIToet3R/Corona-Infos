import 'package:geolocator/geolocator.dart';

class LocationForData {

  final Geolocator geoloc = Geolocator()..forceAndroidLocationManager;
  bool serviceEnabled;

  Position _currentPosition;
  String currentLocationZip;
  String currentLocationCity;

  /*
   * Ueberpruefe ob die notwendigen Berechtigungen vorliegen und starte die
   * Standortabfrage
   */
  Future<void> getCurrentLocationZip() async{
    serviceEnabled = await Geolocator().isLocationServiceEnabled();
    if(!serviceEnabled) return Future.error('Location Service is disabled.');
    await this._getCurrentLocation();
  }

  /*
   * Ermittelt mithilfe von GPS den Laengen- und Breitengrad des aktuellen Standorts und
   * speichert diese als Position
   */
  Future<void> _getCurrentLocation() async{
    try{
      this._currentPosition =  await geoloc.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
       await this._getCurrentAdress();
    }catch(e){
      print(e);
    }
  }

  /*
   * Ermittelt anhand der aktuellen Position den Name des Ortes, an welchem man sich befindet,
   * sowie die PLZ dieses Ortes, und speichert diese Daten in den Objektvariablen ab.
   */
  _getCurrentAdress() async{
    try{
      List<Placemark> p = await geoloc.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      this.currentLocationZip = "${place.postalCode}";
      this.currentLocationCity = "${place.locality}";
      print("Mapped on zip. Location Request complete");
    } catch (e) {
      print(e);
    }
  }
}