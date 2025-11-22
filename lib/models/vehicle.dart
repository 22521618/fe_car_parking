import 'resident.dart';

class Vehicle {
  final String id;
  final String licensePlate;
  final Resident? resident;
  final String residentId; // For creation/update
  final String vehicleType;
  final String brand;
  final String color;
  final String status;

  Vehicle({
    required this.id,
    required this.licensePlate,
    this.resident,
    required this.residentId,
    required this.vehicleType,
    required this.brand,
    required this.color,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      resident: json['residentId'] is Map<String, dynamic>
          ? Resident.fromJson(json['residentId'])
          : null,
      residentId: json['residentId'] is String
          ? json['residentId']
          : (json['residentId']?['_id'] ?? ''),
      vehicleType: json['vehicleType'] ?? '',
      brand: json['brand'] ?? '',
      color: json['color'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'licensePlate': licensePlate,
      'residentId': residentId,
      'vehicleType': vehicleType,
      'brand': brand,
      'color': color,
      'status': status,
    };
  }
}
