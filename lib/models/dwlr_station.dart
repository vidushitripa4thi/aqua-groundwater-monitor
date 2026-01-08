class DWLRStation {
  final String id;
  final String name;
  final String state;
  final String district;
  final double latitude;
  final double longitude;
  final double elevation;
  final String aquiferType;
  final DateTime installationDate;
  final bool isActive;

  DWLRStation({
    required this.id,
    required this.name,
    required this.state,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.aquiferType,
    required this.installationDate,
    this.isActive = true,
  });

  factory DWLRStation.fromJson(Map<String, dynamic> json) {
    return DWLRStation(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      district: json['district'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      aquiferType: json['aquifer_type'] as String,
      installationDate: DateTime.parse(json['installation_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'aquifer_type': aquiferType,
      'installation_date': installationDate.toIso8601String(),
      'is_active': isActive,
    };
  }
}
