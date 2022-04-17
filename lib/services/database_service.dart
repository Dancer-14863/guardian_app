import 'package:guardian_app/models/models.dart';

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
}
