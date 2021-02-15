import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {

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
                  color: Color(0xFF90ee90) // Hintergrundfarbe
              ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 30, 10, 10), // abstand der grauen infobox zu den rändern
              height: data.size.height, // höhe und breite der Infobox
              width: data.size.width,
              decoration: BoxDecoration( // Design der Grauen infobox
                color: Colors.grey.withOpacity(0.5), // Transparenz
                borderRadius: const BorderRadius.all(const Radius.circular(6)), // runde Ecken
              ),
              child: ListView( // bietet die möglichkeit zu scorllen
                children: [
                  ListTile( // Einträge in der Liste ListView
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black, size: 40), // Welches Icon und Design des Icons
                      onPressed: () {
                        Navigator.pop(context); // was soll pasoeren wenn man den Butten drückt? auf welche seite gelangt man
                      },
                    ),
                    title: Text( // überschrift des absatzes
                      "To Do List",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      "In der häuslichen Quarantäne",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Was darf ich nicht tun, wenn ich in Quarantäne bin?",
                      style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.clear, color: Colors.black, size: 40),
                    subtitle: Text( // unterüberschrift eigentlicher inhalt der info box
                      "Sie dürfen Ihre Wohnung ohne Zustimmung des Gesundheitsamtes nicht verlassen.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.clear, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Sie dürfen keinen Besuch von Personen empfangen, die nicht zum eigenen Haushalt gehören.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.clear, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Sie dürfen keinen engen Kontakt zu Personen haben, mit denen Sie zusammenleben.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Wie soll ich mich in der Quarantäne verhalten?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Informieren Sie sich über örtliche Vorschriften.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Achten Sie auf regelmäßiges Händewaschen.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Lüften Sie Wohnungsräume und Schlafräume gut und regelmäßig.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Wenn Sie einen Hund haben, bitten Sie Freunde oder Nachbarn, mit ihm in der Zeit der Quarantäne spazieren zu gehen.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Oberflächen wie Türklinken, Tische, Ablageflächen sollten Sie regelmäßig und gründlich reinigen und, wenn möglich, desinfizieren.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Mahlzeiten sollten getrennt voneinander eingenommen werden.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Teilen Sie Haushaltsgegenstände wie beispielsweise Geschirr, Wäsche und Handtücher nicht miteinander.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.done, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Teilen Sie Hygieneartikel nicht miteinander, waschen Sie Wäsche regelmäßig und gründlich.",
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