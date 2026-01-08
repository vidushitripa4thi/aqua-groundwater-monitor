import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dwlr_station.dart';
import '../models/water_level_reading.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of real-time water level readings for a station
  Stream<List<WaterLevelReading>> watchStationReadings(
    String stationId, {
    int limit = 100,
  }) {
    return _firestore
        .collection('dwlr_stations')
        .doc(stationId)
        .collection('readings')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WaterLevelReading.fromJson(doc.data()))
            .toList());
  }

  // Get latest reading for a station
  Future<WaterLevelReading?> getLatestReading(String stationId) async {
    try {
      final snapshot = await _firestore
          .collection('dwlr_stations')
          .doc(stationId)
          .collection('readings')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return WaterLevelReading.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting latest reading: $e');
      return null;
    }
  }

  // Save reading to Firebase
  Future<void> saveReading(
    String stationId,
    WaterLevelReading reading,
  ) async {
    try {
      await _firestore
          .collection('dwlr_stations')
          .doc(stationId)
          .collection('readings')
          .doc(reading.id)
          .set(reading.toJson());
    } catch (e) {
      print('Error saving reading: $e');
      rethrow;
    }
  }

  // Get stations with critical water levels
  Stream<List<DWLRStation>> watchCriticalStations() {
    return _firestore
        .collection('dwlr_stations')
        .where('current_status', isEqualTo: 'critical')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DWLRStation.fromJson(doc.data()))
            .toList());
  }

  // Update station status
  Future<void> updateStationStatus(
    String stationId,
    String status,
  ) async {
    try {
      await _firestore
          .collection('dwlr_stations')
          .doc(stationId)
          .update({'current_status': status});
    } catch (e) {
      print('Error updating station status: $e');
      rethrow;
    }
  }
}
