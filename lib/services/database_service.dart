import 'package:guardian_app/models/models.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  Future<Configuration?> fetchLatestConfiguration() async {
    return await Configuration().select().orderByDesc('id').toSingle();
  }

  Future<void> updateLatestConfigurationWaterGunStatus(bool state) async {
    Configuration? configuration = await fetchLatestConfiguration();
    configuration!.activateWaterGun = state;
    await configuration.save();
  }

  Future<void> updateLatestConfigurationDistanceAlarmThreshold(
    int value,
  ) async {
    Configuration? configuration = await fetchLatestConfiguration();
    configuration!.distanceAlarmTrigger = value;
    await configuration.save();
  }

  Future<void> createDistanceLog(int distance) async {
    await DistanceLog(recordedDistance: distance).save();
  }

  Future<void> createPressurePlateLog(int pressedPressurePlate) async {
    await PressurePlateLog(triggeredPressurePlate: pressedPressurePlate).save();
  }

  Future<void> createAlarmLog() async {
    await AlarmLog().save();
  }

  Future<void> createWaterGunLog(int deployedSector) async {
    await WaterGunLog(deployedSector: deployedSector).save();
  }

  Future<List<DistanceLog>> fetchAllDistanceLogs() async {
    return await DistanceLog().select().orderByDesc('id').toList();
  }

  Future<List<PressurePlateLog>> fetchAllPressurePlateLogs() async {
    return await PressurePlateLog().select().orderByDesc('id').toList();
  }

  Future<List<WaterGunLog>> fetchAllWaterGunLogs() async {
    return await WaterGunLog().select().orderByDesc('id').toList();
  }

  Future<int> fetchNumberOfAlarmLogs() async {
    return await AlarmLog().select().toCount();
  }

  Future<AlarmLog?> fetchLatestAlarmLog() async {
    return await AlarmLog().select().orderByDesc('id').toSingle();
  }
}
