
import 'dart:convert';

import 'package:assignment/data/bike_model.dart';

Bike getBike() {
  final bikeString = """
  {
    "odo": 2001,
    "frameNumber": "EFY111222",
    "firmware": "1.2.1",
    "warranty": 1.5,
    "batteryCharge": 99.2,
    "batteryType": "BA184751",
    "batteryHealth": 99,
    "batteryFirmware": "2.08",
    "batteryWarranty": 1.5,
    "motorType": "Bafang M420",
    "motorSerialNumber": "BAFA8466578489",
    "motorFirmware": "2.034",
    "motorWarranty": 2
}""";

  return Bike.fromJson(jsonDecode(bikeString));
}