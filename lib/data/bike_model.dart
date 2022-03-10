class Bike {
  final int odo;
  final String frameNumber;
  final String firmware;
  final double warranty;
  final double batteryCharge;
  final String batteryType;
  final int batteryHealth;
  final String batteryFirmware;
  final double batteryWarranty;
  final String motorType;
  final String motorSerialNumber;
  final String motorFirmware;
  final double motorWarranty;

  Bike(
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

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      json['odo'] as int,
      json['frameNumber'] as String,
      json['firmware'] as String,
      double.parse(json['warranty'].toString()),
      double.parse(json['batteryCharge'].toString()),
      json['batteryType'] as String,
      json['batteryHealth'] as int,
      json['batteryFirmware'] as String,
      double.parse(json['batteryWarranty'].toString()),
      json['motorType'] as String,
      json['motorSerialNumber'] as String,
      json['motorFirmware'] as String,
      double.parse(json['motorWarranty'].toString()),
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
}
