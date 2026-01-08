class WaterLevelReading {
  final String id;
  final String stationId;
  final DateTime timestamp;
  final double waterLevel; // in meters below ground level
  final double? temperature;
  final double? rainfall;
  final String quality; // 'good', 'moderate', 'critical'

  WaterLevelReading({
    required this.id,
    required this.stationId,
    required this.timestamp,
    required this.waterLevel,
    this.temperature,
    this.rainfall,
    required this.quality,
  });

  factory WaterLevelReading.fromJson(Map<String, dynamic> json) {
    return WaterLevelReading(
      id: json['id'] as String,
      stationId: json['station_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      waterLevel: (json['water_level'] as num).toDouble(),
      temperature: json['temperature'] != null 
          ? (json['temperature'] as num).toDouble() 
          : null,
      rainfall: json['rainfall'] != null 
          ? (json['rainfall'] as num).toDouble() 
          : null,
      quality: json['quality'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'timestamp': timestamp.toIso8601String(),
      'water_level': waterLevel,
      'temperature': temperature,
      'rainfall': rainfall,
      'quality': quality,
    };
  }

  // Helper method to determine status color
  String getStatusColor() {
    switch (quality.toLowerCase()) {
      case 'good':
        return '#4CAF50';
      case 'moderate':
        return '#FF9800';
      case 'critical':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }
}
