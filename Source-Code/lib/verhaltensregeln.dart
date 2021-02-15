import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return MaterialApp(
      //MaterialApp(
      debugShowCheckedModeBanner: false, //Banner Oben rechts
      home: Scaffold(
        body: Stack(
          children: [
            Container(
                color: Color(0xFF90ee90) // hintergrundfarbe
            ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 30, 10, 10), // abstand der grauen infobox zu den rändern
            height: data.size.height, // höhe und breite der Infobox
            width: data.size.width,
            decoration: BoxDecoration(  // Design der Grauen infobox
              color: Colors.grey.withOpacity(0.5), // Transparenz
              borderRadius: const BorderRadius.all(const Radius.circular(6)), // runde Ecken
            ),
            child: ListView( // bietet die möglichkeit zu scorllen
              children: [
                ListTile( // Einträge in der Liste ListView
                  leading: IconButton(
                    icon:
                    Icon(Icons.arrow_back, color: Colors.black, size: 40), // Welches Icon und Design des Icons
                    onPressed: () {
                      Navigator.pop(context); // was soll pasoeren wenn man den Butten drückt? auf welche seite gelangt man
                    },
                  ),
                  title: Text(
                    "Verhalten",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  title: Text(
                    "AHA-Formel",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  leading:
                  Icon(Icons.six_ft_apart, color: Colors.black, size: 40),
                  title: Text( // überschrift des absatzes
                    "Abstand halten: ",
                    style: TextStyle( // unterüberschrift eigentlicher inhalt der info box
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Achten Sie auf einen Mindestabstand von mindestens 1.5 Meter zu anderen Personen.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.wash, color: Colors.black, size: 40),
                  title: Text(
                    "Hygiene beachten: ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Befolgen Sie die Hygieneregeln in Bezug auf Niesen, Husten und Händewaschen.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.masks, color: Colors.black, size: 40),
                  title: Text(
                    "Alltagsmasken: ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Tragen Sie eine Alltagsmaske bzw. medzinische oder FFP2-Maske dort, wo es vorgeschrieben ist. Bleiben Sie informiert über die aktuellen Bestimmungen.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Privates Umfeld und Familienleben",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  leading:
                  Icon(Icons.location_on, color: Colors.black, size: 40),
                  subtitle: Text(
                    "Informieren Sie sich über örtliche Vorschriften.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.local_hospital,
                      color: Colors.black, size: 40),
                  subtitle: Text(
                    "Beachten Sie bestehende Besuchs- regelungen für Krankenhäuser, Pflege-, Senioren- und Behinderteneinrichtungen.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.black, size: 40),
                  subtitle: Text(
                    "Bleiben Sie, so oft es geht, zu Hause. Beschränken Sie insbesondere die persönlichen Begegnungen mit älteren oder chronisch kranken Menschen zu deren Schutz.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Berufliches Umfeld",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  leading:
                  Icon(Icons.home_work, color: Colors.black, size: 40),
                  subtitle: Text(
                    "Informieren Sie sich über örtliche Vorschriften.",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.black, size: 40),
                  subtitle: Text(
                    "Arbeiten Sie, wenn möglich, einzeln oder in kleinen festen Teams (z.B.  auf Baustellen oder in Büroräumen).",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              padding: EdgeInsets.all(1.0), // abstand der listview zu den rändern der Grauen box
            ),
          ),
            Align(
              alignment: Alignment(0.95,0.9), // Position der Quelle
              child: RotatedBox( // Quellen eintrag Quer gschrieben
                quarterTurns: 1, // wie es gedreht wird
                child: Text('infektionsschutz.de',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
