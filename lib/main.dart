import 'package:assignment/bike_details/bike_details.dart';
import 'package:assignment/data/bike_api.dart';
import 'package:assignment/bike_viewmodel.dart';
import 'package:assignment/data/bike_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

const primaryColor = Color(0xFFFF8200);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //This would be more complete if the app theme was available
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor, primary: primaryColor),
      ).copyWith(iconTheme: IconThemeData(color: primaryColor)),
      home: Provider(
          create: (_) => BikeViewModel(BikeRepository(BikeApi(Client()))),
          child: BikeDetails()),
    );
  }
}
