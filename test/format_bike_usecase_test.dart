import 'dart:convert';

import 'package:assignment/data/bike_model.dart';
import 'package:assignment/formate_bike_info_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_data.dart';

void main() {
  // There would be more tests in a real project, these are for demonstration
  group('format bike info use case', () {
    test('should return 15 bike info', () {
      final bike = getBike();

      var bikeInfoList = FormatBikeInfoUseCase(bike).format();

      expect(bikeInfoList.length, equals(15),
          reason: 'bike info list should be 15 but was ${bikeInfoList.length}');
    });

    test('should return bike info with 2 headers, battery and motor', () {
      final bike = getBike();

      var bikeInfoList = FormatBikeInfoUseCase(bike).format();

      final List<BikeInfoHeader> headers =
          List.from(bikeInfoList.where((element) => element is BikeInfoHeader));

      expect(headers.length, equals(2),
          reason: 'expected 2 headers but found ${headers.length}');
      expect(headers.first.header, equals('Battery'));
      expect(headers.elementAt(1).header, equals('Motor'));
    });
  });
}
