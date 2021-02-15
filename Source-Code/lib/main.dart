// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart';
import 'API/RKIAPIBL.dart';
import 'API/RKIAPILK.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //This Widget is the root of your application
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Banner Oben rechts
      title: 'Corona App',
      home: HomeScreen(),
    );
  }
}