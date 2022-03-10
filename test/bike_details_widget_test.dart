import 'package:assignment/bike_details/bike_details.dart';
import 'package:assignment/bike_service.dart';
import 'package:assignment/bike_viewmodel.dart';
import 'package:assignment/data/bike_model.dart';
import 'package:assignment/data/bike_repository.dart';
import 'package:assignment/formate_bike_info_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'fake_data.dart';

class _FakeBikeViewModel extends BikeViewModel {
  _FakeBikeViewModel() : super(BikeRepository(BikeApi(Client())));

  @override
  Future<List<BaseBikeInfo>> getBikeData() async {
    return FormatBikeInfoUseCase(getBike()).format();
  }
}

void main() {
  // there would be more tests in a real project
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final viewModel = _FakeBikeViewModel();
    await tester.pumpWidget(MaterialApp(
      home: Provider<BikeViewModel>.value(value: viewModel, child: BikeDetails()),
    ));

    await tester.pump();


    final bikeInfoList = await viewModel.getBikeData();
    final headersCount =
        bikeInfoList.where((element) => element is BikeInfoHeader).length;
    expect(find.byType(PaddedHeader), findsNWidgets(headersCount));
  });
}
