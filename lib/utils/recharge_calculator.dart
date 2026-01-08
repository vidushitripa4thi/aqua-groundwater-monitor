import '../models/water_level_reading.dart';

class RechargeCalculator {
  /// Calculate groundwater recharge based on water level changes
  /// 
  /// Parameters:
  /// - currentLevel: Current water level (m below ground)
  /// - previousLevel: Previous water level (m below ground)
  /// - aquiferArea: Area of aquifer (sq km)
  /// - specificYield: Specific yield of aquifer (0-1)
  /// 
  /// Returns: Recharge volume in million cubic meters (MCM)
  static double calculateRecharge({
    required double currentLevel,
    required double previousLevel,
    required double aquiferArea,
    required double specificYield,
  }) {
    // Water level rise (negative because levels are below ground)
    final levelChange = previousLevel - currentLevel;
    
    // If level rose (positive change), calculate recharge
    if (levelChange > 0) {
      // Convert area from sq km to sq m
      final areaInSqM = aquiferArea * 1000000;
      
      // Calculate volume: Area × Rise × Specific Yield
      final volumeInCubicM = areaInSqM * levelChange * specificYield;
      
      // Convert to MCM (Million Cubic Meters)
      return volumeInCubicM / 1000000;
    }
    
    return 0.0; // No recharge if water level dropped
  }

  /// Calculate seasonal recharge pattern
  static Map<String, double> calculateSeasonalRecharge(
    List<WaterLevelReading> readings,
    double aquiferArea,
    double specificYield,
  ) {
    final seasons = {
      'Monsoon': 0.0,      // June-September
      'Post-Monsoon': 0.0, // October-November
      'Winter': 0.0,       // December-February
      'Summer': 0.0,       // March-May
    };

    for (int i = 1; i < readings.length; i++) {
      final current = readings[i];
      final previous = readings[i - 1];
      
      final recharge = calculateRecharge(
        currentLevel: current.waterLevel,
        previousLevel: previous.waterLevel,
        aquiferArea: aquiferArea,
        specificYield: specificYield,
      );

      final season = _getSeason(current.timestamp.month);
      seasons[season] = (seasons[season] ?? 0) + recharge;
    }

    return seasons;
  }

  /// Calculate recharge efficiency (recharge vs rainfall)
  static double calculateRechargeEfficiency({
    required double totalRecharge,
    required double totalRainfall,
    required double catchmentArea,
  }) {
    if (totalRainfall == 0) return 0.0;
    
    // Convert rainfall (mm) to volume (MCM)
    final rainfallVolume = (totalRainfall / 1000) * catchmentArea;
    
    // Efficiency = (Recharge / Rainfall) × 100
    return (totalRecharge / rainfallVolume) * 100;
  }

  /// Estimate future water level based on trend
  static double predictWaterLevel(
    List<WaterLevelReading> historicalData,
    int daysAhead,
  ) {
    if (historicalData.length < 2) {
      return historicalData.isNotEmpty 
          ? historicalData.first.waterLevel 
          : 0.0;
    }

    // Simple linear regression
    final n = historicalData.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for (int i = 0; i < n; i++) {
      final x = i.toDouble();
      final y = historicalData[i].waterLevel;
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    // Calculate slope and intercept
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    // Predict future level
    return slope * (n + daysAhead) + intercept;
  }

  static String _getSeason(int month) {
    if (month >= 6 && month <= 9) return 'Monsoon';
    if (month >= 10 && month <= 11) return 'Post-Monsoon';
    if (month >= 12 || month <= 2) return 'Winter';
    return 'Summer';
  }
}
