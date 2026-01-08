import 'package:dio/dio.dart';
import '../models/dwlr_station.dart';
import '../models/water_level_reading.dart';

class APIService {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://api.data.gov.in/resource';
  static const String apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual key

  APIService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'api-key': apiKey,
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Fetch all DWLR stations
  Future<List<DWLRStation>> fetchAllStations() async {
    try {
      final response = await _dio.get('/dwlr-stations');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['records'];
        return data.map((json) => DWLRStation.fromJson(json)).toList();
      }
      throw Exception('Failed to load stations');
    } catch (e) {
      print('Error fetching stations: $e');
      rethrow;
    }
  }

  // Fetch station by ID
  Future<DWLRStation> fetchStationById(String stationId) async {
    try {
      final response = await _dio.get('/dwlr-stations/$stationId');
      
      if (response.statusCode == 200) {
        return DWLRStation.fromJson(response.data);
      }
      throw Exception('Failed to load station');
    } catch (e) {
      print('Error fetching station: $e');
      rethrow;
    }
  }

  // Fetch water level readings for a station
  Future<List<WaterLevelReading>> fetchStationReadings(
    String stationId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = {
        'station_id': stationId,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final response = await _dio.get(
        '/water-level-readings',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['records'];
        return data.map((json) => WaterLevelReading.fromJson(json)).toList();
      }
      throw Exception('Failed to load readings');
    } catch (e) {
      print('Error fetching readings: $e');
      rethrow;
    }
  }

  // Fetch stations by state
  Future<List<DWLRStation>> fetchStationsByState(String state) async {
    try {
      final response = await _dio.get(
        '/dwlr-stations',
        queryParameters: {'state': state},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['records'];
        return data.map((json) => DWLRStation.fromJson(json)).toList();
      }
      throw Exception('Failed to load stations by state');
    } catch (e) {
      print('Error fetching stations by state: $e');
      rethrow;
    }
  }
}
