import 'package:assignment/data/bike_service.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}"""
      ;
  test('successful getBikeModel returns a bike model', () async {
    final endpoints = BikeApiEndpoints();
    final client = MockClient((request) async {
      if (request.url.toString() == endpoints.bikeInfoUrl) {
        return Response(bikeString, 200);
      }
      throw UnsupportedError('${request.url.path} is not supported');
    });
    final bike = await BikeApi(client, endpoints: endpoints).getBikeModel();
    expect(bike, isNotNull);
  });

  test('failed getBikeModel throws an exception', () async {
    final endpoints = BikeApiEndpoints();
    final client = MockClient((request) async {
      throw UnsupportedError('${request.url.path} is not supported');
    });

    try {
      await BikeApi(client, endpoints: endpoints).getBikeModel();
      fail('no exception was thrown');
    } catch (e) {
      expect(e, isA<Exception>());
    }
  });
}
