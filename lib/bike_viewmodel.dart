
import 'package:assignment/data/bike_repository.dart';
import 'package:assignment/formate_bike_info_usecase.dart';

class BikeViewModel {

  final BikeRepository _bikeRepository;

  BikeViewModel(this._bikeRepository);

  Future<List<BaseBikeInfo>> getBikeData() async {
    return _bikeRepository.fetchBike().then((bike) {
      return FormatBikeInfoUseCase(bike).format();
    });
  }

}