import 'package:flutter/material.dart';

class Page5 extends StatelessWidget {

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
                      icon:
                          Icon(Icons.arrow_back, color: Colors.black, size: 40), // Welches Icon und Design des Icons
                      onPressed: () {
                        Navigator.pop(
                            context); // was soll pasoeren wenn man den Butten drückt? auf welche seite gelangt man
                      },
                    ),
                    title: Text(
                      "Symptome von COVID-19",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Symptome",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.priority_high, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Die häufigsten Krankheitszeichen einer Infektion mit dem Coronavirus sind Husten und Fieber.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.priority_high, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Weitere häufige Symptome sind Schnupfen oder eine Störungen des Geruchs- oder Geschmackssinns.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.priority_high, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Weitere Symptome wie Halsschmerzen, Atemnot, Kopf- und Gliederschmerzen sowie allgemeine Schwäche können hinzukommen.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Krankheitsverlauf von COVID-19",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.priority_high, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Die Krankheitsverläufe sind häufig unspezifisch, vielfältig und variieren stark.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.priority_high, color: Colors.black, size: 40),
                    subtitle: Text( // überschrift des absatzes
                      "Eine Infektion kann ganz ohne Krankheitszeichen bleiben, es kann aber auch zu leichten oder schweren Symptomen kommen.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Verhalten bei Krankheitszeichen",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Bleiben Sie zu Hause und schränken Sie auch dort direkte Kontakte ein.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_hospital,
                        color: Colors.black, size: 40),
                    subtitle: Text( // unterüberschrift eigentlicher inhalt der info box
                      "Verständigen Sie Ihren Arzt , wenn Sie das Gefühl haben, schwerer Luft zu bekommen als sonst.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_hospital,
                        color: Colors.black, size: 40),
                    subtitle: Text(
                      "Rufen Sie Ihren Arzt vor dem Besuch an, wenn Sie das Gefühl haben, an Corona erkrankt zu sein!",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.six_ft_apart, color: Colors.black, size: 40),
                    subtitle: Text(
                      "Beachten Sie die AHA (Abstand, Hygiene, Alltagsmaske) Formel, um Ihre mit Menschen zu schützen.",
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
