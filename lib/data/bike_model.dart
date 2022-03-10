class Bike {
  final int odo;
  final String frameNumber;
  final String firmware;
  final double warranty;
  final double batteryCharge;
  final String batteryType;
  final double batteryHealth;
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
      json['warranty'] as double,
      json['batteryCharge'] as double,
      json['batteryType'] as String,
      json['batteryHealth'] as double,
      json['batteryFirmware'] as String,
      json['batteryWarranty'] as double,
      json['motorType'] as String,
      json['motorSerialNumber'] as String,
      json['motorFirmware'] as String,
      json['motorWarranty'] as double,
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
