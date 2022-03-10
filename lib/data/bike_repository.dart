import 'package:assignment/bike_service.dart';
import 'package:assignment/data/bike_model.dart';

class BikeRepository {
  // Normally this would be a data source rather
  // than it directly being the api layer, this is just because this assignment
  // is small
  final BikeApi _bikeApi;

  BikeRepository(this._bikeApi);

  Future<Bike> fetchBike() {
    return _bikeApi.getBikeModel();
  }


}