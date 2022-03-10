import 'dart:convert';

import 'package:http/http.dart' as http;

import 'data/bike_model.dart';

class BikeApiEndpoints {
  final String bikeInfoUrl;

  const BikeApiEndpoints(
      {this.bikeInfoUrl =
          'https://sp82l5ulp2.execute-api.eu-west-1.amazonaws.com/bikeDetails'});
}

class BikeApi {
  final http.Client client;
  final BikeApiEndpoints endpoints;

  const BikeApi(this.client, {this.endpoints = const BikeApiEndpoints()});

  Future<Bike> getBikeModel() async {
    try {
      final response = await client.get(Uri.parse(endpoints.bikeInfoUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return Bike.fromJson(jsonData);
      } else
        throw Exception('error from the server');
    } catch (e) {
      throw Exception('error from the server');
    }
  }
}
