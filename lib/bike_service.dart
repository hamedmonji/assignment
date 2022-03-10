import 'dart:convert';

import 'package:http/http.dart' as http;

import 'data/bike_model.dart';

//TODO make proper testable bike api
class BikeApi {
  Future<Bike> getBikeModel() async {
    final response = await http.get(Uri.parse(
        'https://sp82l5ulp2.execute-api.eu-west-1.amazonaws.com/bikeDetails'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Bike.fromJson(jsonData);
    } else
      throw Exception('error from the server');
  }
}
