class AccessLog {
  final String id;
  final String licensePlate;
  final String action;
  final DateTime timestamp;
  final String raspberryPiId;
  final String? image;
  final bool isAuthorized;
  final String responseStatus;
  final String? errorMessage;

  AccessLog({
    required this.id,
    required this.licensePlate,
    required this.action,
    required this.timestamp,
    required this.raspberryPiId,
    this.image,
    required this.isAuthorized,
    required this.responseStatus,
    this.errorMessage,
  });

  factory AccessLog.fromJson(Map<String, dynamic> json) {
    return AccessLog(
      id: json['_id'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      action: json['action'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      raspberryPiId: json['raspberryPiId'] ?? '',
      image: json['image'],
      isAuthorized: json['isAuthorized'] ?? false,
      responseStatus: json['responseStatus'] ?? '',
      errorMessage: json['errorMessage'],
    );
  }
}
