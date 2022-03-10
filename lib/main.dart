import 'package:assignment/bike_details/bike_details.dart';
import 'package:assignment/bike_service.dart';
import 'package:assignment/bike_viewmodel.dart';
import 'package:assignment/data/bike_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

const primaryColors = Color(0xFFFF8200);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          iconTheme: IconThemeData(color: primaryColors)),
      home: Provider(
          create: (_) => BikeViewModel(BikeRepository(BikeApi())),
          child: BikeDetails()),
    );
  }
}


