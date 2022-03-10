import 'package:assignment/data/bike_model.dart';

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

class FormatBikeInfoUseCase {
  final Bike model;

  FormatBikeInfoUseCase(this.model);

  List<BaseBikeInfo> format() {
    return [
      BikeInfo('ODO', '${model.odo} km'),
      BikeInfo('Frame number', model.frameNumber),
      BikeInfo('Firmware', model.firmware),
      BikeInfo('Warranty', '${model.warranty} years'),
      BikeInfoHeader('Battery'),
      BikeInfo('Charge', "${model.batteryCharge}%"),
      BikeInfo('Type', model.batteryType),
      //There would be some logic to determine what the postfix would be,
      // however since i do not know the ui logic for
      // this part(at what percentage show what) it's hardcoded
      BikeInfo('Health', '${model.batteryHealth}% very good'),
      BikeInfo('Firmware', model.batteryFirmware),
      BikeInfo('Warranty', '${model.batteryWarranty} years'),
      BikeInfoHeader('Motor'),
      BikeInfo('Type', model.motorType),
      BikeInfo('Serial number', model.motorSerialNumber),
      BikeInfo('Firmware', model.motorFirmware),
      BikeInfo('Warranty', '${model.motorWarranty} years'),
    ];
  }
}
