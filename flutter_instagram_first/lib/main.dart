import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/material_white.dart';
import 'package:flutter_instagram_first/home_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(primarySwatch: white),
    );
  }

}

