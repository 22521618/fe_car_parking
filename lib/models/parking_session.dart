import 'resident.dart';
import 'vehicle.dart';

class ParkingSession {
  final String id;
  final String licensePlate;
  final Vehicle? vehicle;
  final Resident? resident;
  final DateTime entryTime;
  final DateTime? exitTime;
  final String? entryImage;
  final String? exitImage;
  final int? duration;
  final String status;

  ParkingSession({
    required this.id,
    required this.licensePlate,
    this.vehicle,
    this.resident,
    required this.entryTime,
    this.exitTime,
    this.entryImage,
    this.exitImage,
    this.duration,
    required this.status,
  });

  factory ParkingSession.fromJson(Map<String, dynamic> json) {
    return ParkingSession(
      id: json['_id'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      vehicle: json['vehicleId'] is Map<String, dynamic>
          ? Vehicle.fromJson(json['vehicleId'])
          : null,
      resident: json['residentId'] is Map<String, dynamic>
          ? Resident.fromJson(json['residentId'])
          : null,
      entryTime:
          DateTime.parse(json['entryTime'] ?? DateTime.now().toIso8601String()),
      exitTime:
          json['exitTime'] != null ? DateTime.parse(json['exitTime']) : null,
      entryImage: json['entryImage'],
      exitImage: json['exitImage'],
      duration: json['duration'],
      status: json['status'] ?? 'unknown',
    );
  }
}
