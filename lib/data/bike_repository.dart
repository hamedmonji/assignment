import 'package:assignment/bike_service.dart';
import 'package:assignment/data/bike_model.dart';

class BikeRepository {

  final BikeApi _bikeApi;

  BikeRepository(this._bikeApi);

  Future<Bike> fetchBike() {
    return _bikeApi.getBikeModel();
  }


}