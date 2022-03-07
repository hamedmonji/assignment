import 'dart:convert';

import 'package:http/http.dart' as http;

class BikeModel {
  final int odo;
  final String frameNumber;
  final String firmware;
  final double warranty;
  final double batteryCharge;
  final String batteryType;
  final double batteryHealth;
  final String batteryFirmware;
  final double batteryWarranty;
  final String motorType;
  final String motorSerialNumber;
  final String motorFirmware;
  final double motorWarranty;

  BikeModel(
      this.odo,
      this.frameNumber,
      this.firmware,
      this.warranty,
      this.batteryCharge,
      this.batteryType,
      this.batteryHealth,
      this.batteryFirmware,
      this.batteryWarranty,
      this.motorType,
      this.motorSerialNumber,
      this.motorFirmware,
      this.motorWarranty);

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      json['odo'] as int,
      json['frameNumber'] as String,
      json['firmware'] as String,
      json['warranty'] as double,
      json['batteryCharge'] as double,
      json['batteryType'] as String,
      json['batteryHealth'] as double,
      json['batteryFirmware'] as String,
      json['batteryWarranty'] as double,
      json['motorType'] as String,
      json['motorSerialNumber'] as String,
      json['motorFirmware'] as String,
      json['motorWarranty'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'odo': odo,
      'frameNumber': frameNumber,
      'firmware': firmware,
      'warranty': warranty,
      'batteryCharge': batteryCharge,
      'batteryType': batteryType,
      'batteryHealth': batteryHealth,
      'batteryFirmware': batteryFirmware,
      'batteryWarranty': batteryWarranty,
      'motorType': motorType,
      'motorSerialNumber': motorSerialNumber,
      'motorFirmware': motorFirmware,
      'motorWarranty': motorWarranty
    };
  }

  List<BaseBikeInfo> bikeInfo() => [
        BikeInfo('ODO', odo.toString()),
        BikeInfo('Frame number', frameNumber),
        BikeInfo('Firmware', firmware),
        BikeInfo('Warranty', warranty.toString()),
        BikeInfoHeader('Battery'),
        BikeInfo('Charge', batteryCharge.toString()),
        BikeInfo('Type', batteryType),
        BikeInfo('Health', batteryHealth.toString()),
        BikeInfo('Firmware', batteryFirmware),
        BikeInfo('Warranty', batteryWarranty.toString()),
        BikeInfoHeader('Motor'),
        BikeInfo('Type', motorType),
        BikeInfo('Serial number', motorSerialNumber),
        BikeInfo('Firmware', motorFirmware),
        BikeInfo('Warranty', motorWarranty.toString()),
      ];
}

abstract class BaseBikeInfo {}

class BikeInfo extends BaseBikeInfo {
  final String title;
  final String info;

  BikeInfo(this.title, this.info);
}

class BikeInfoHeader extends BaseBikeInfo {
  final String header;

  BikeInfoHeader(this.header);
}

//TODO make proper testable bike api
class BikeApi {
  Future<BikeModel> getBikeModel() async {
    final response = await http.get(Uri.parse(
        'https://sp82l5ulp2.execute-api.eu-west-1.amazonaws.com/bikeDetails'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return BikeModel.fromJson(jsonData);
    } else
      throw Exception('error from the server');
  }
}
