class Resident {
  final String id;
  final String fullName;
  final String apartmentNumber;
  final String phoneNumber;
  final String email;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Resident({
    required this.id,
    required this.fullName,
    required this.apartmentNumber,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      apartmentNumber: json['apartmentNumber'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'active',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'apartmentNumber': apartmentNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
