import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/API/RKIAPILK.dart';
import 'package:flutter_app/Logik/LocationForData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../home_screen.dart';


class DatabaseHelper {
  //ToDo: Nicht benoetigte Attribute  entfernen
  final _databaseName = "locations.db";
  final _databaseVersion = 1;
  String locationzip = LocationForData().currentLocationZip;


  // Ausführen der Methode zur Postleitzahl/Variablen zuweisung
  //String location = HomeScreenState().changeAddressZipcodeToAdress();

    DatabaseHelper._privateConstructor();
    static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

    // only have a single app-wide reference to the database
    static Database _database;
    Future<Database> get database async {
      if (_database != null) return _database;
      // lazily instantiate the db the first time it is accessed
      _database = await _initDatabase();
      return _database;
    }

    // Datenbankinitialisierung
    _initDatabase() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);
      ByteData data = await rootBundle.load("assets/locations.db");
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      return await openDatabase(path, version: _databaseVersion);
    }

    Future<List<Map<String, dynamic>>> queryZipToLkr(String code) async {
      Database db = await instance.database;
      return await db.rawQuery('''
        Select county From location WHERE zipcode = $code 
        ''');
    }
  }
