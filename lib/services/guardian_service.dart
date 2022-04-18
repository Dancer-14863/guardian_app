import 'dart:async';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/models/models.dart';
import 'package:guardian_app/services/database_service.dart';
import 'package:guardian_app/services/serial_service.dart';
import 'package:guardian_app/utils/constants/commands.dart';
import 'package:guardian_app/utils/constants/status.dart';
import 'package:guardian_app/utils/toast_helpers.dart';
import 'package:intl/intl.dart';

final serialService = Provider((_) => SerialService());
final databaseService = Provider((_) => DatabaseService());
final isDeviceConnected = StateProvider((_) => false);
final isDeviceActive = StateProvider((_) => false);
final isDeviceInAlarmState = StateProvider((_) => false);
final shouldWaterGunBeOn = StateProvider((_) => false);
final distanceAlarmThreshold = StateProvider((_) => 0);

class GuardianService {
  late Ref ref;

  late SerialService _serialService;
  late DatabaseService _databaseService;
  Isolate? _isolate;
  ReceivePort? _receivePort;

  GuardianService(this.ref) {
    _serialService = ref.read(serialService);
    _databaseService = ref.read(databaseService);
    _loadFromConfiguration();
  }

  Future<void> connectToDevice() async {
    await _serialService.connectToArduino();
    _setIsDeviceConnected(true);
  }

  Future<void> disconnectDevice() async {
    if (ref.read(isDeviceConnected)) {
      deactivateDevice();
    }
    await _serialService.disconnectArduino();
    _setIsDeviceConnected(false);
  }

  void activateDevice() {
    _serialService.sendCommand(Commands.handshake);
    setupWaterGun();
    deactivateAlarm();
    _setIsDeviceActive(true);
    _startLogging();
  }

  void deactivateDevice() {
    deactivateAlarm();
    _serialService.sendCommand(Commands.disconnect);
    _setIsDeviceActive(false);
    _stopLogging();
  }

  void deactivateAlarm() {
    _toggleAlarmDevices(false);
    _setIsDeviceInAlarmState(false);
  }

  void setupWaterGun() {
    if (ref.read(shouldWaterGunBeOn)) {
      _serialService.sendCommand(Commands.waterGunOn);
    } else {
      _serialService.sendCommand(Commands.waterGunOff);
    }
  }

  Future<void> setWaterGunStatus(bool state) async {
    _setShouldWaterGunBeOnState(state);
    await _databaseService.updateLatestConfigurationWaterGunStatus(state);
    if (ref.read(isDeviceConnected)) {
      setupWaterGun();
    }
  }

  Future<void> setDistanceAlarmThreshold(int value) async {
    _setDistanceAlarmThresholdValue(value);
    await _databaseService.updateLatestConfigurationDistanceAlarmThreshold(
      value,
    );
  }

  Future<int> getNumberOfAlarmLogs() async {
    return await _databaseService.fetchNumberOfAlarmLogs();
  }

  Future<String> getLatestAlarmDateTime() async {
    DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    AlarmLog? alarmLog = await _databaseService.fetchLatestAlarmLog();
    return alarmLog?.recordedDate != null
        ? formatter.format(alarmLog!.recordedDate!)
        : '-';
  }

  Future<List<DistanceLog>> getDistanceLogs() async {
    return await _databaseService.fetchAllDistanceLogs();
  }

  Future<List<PressurePlateLog>> getPressurePlateLogs() async {
    return await _databaseService.fetchAllPressurePlateLogs();
  }

  Future<List<WaterGunLog>> getWaterGunLogs() async {
    return await _databaseService.fetchAllWaterGunLogs();
  }

  void _startLogging() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort!.sendPort);
    _receivePort!.listen(_process);
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      sendPort.send(null);
    });
  }

  void _process(dynamic data) async {
    int distance = int.tryParse(
          await _serialService.makeTransaction(
                Commands.getDistance,
              ) ??
              '999',
        ) ??
        999;

    if (distance < ref.read(distanceAlarmThreshold)) {
      _databaseService.createDistanceLog(distance);
    }

    int pressedPressurePlate = int.tryParse(
          await _serialService.makeTransaction(
                Commands.getPressureStatus,
              ) ??
              '-1',
        ) ??
        -1;
    if (pressedPressurePlate > 0) {
      _databaseService.createPressurePlateLog(pressedPressurePlate);
    }

    if (!ref.read(isDeviceInAlarmState)) {
      if (pressedPressurePlate > 0 &&
          distance < ref.read(distanceAlarmThreshold)) {
        _databaseService.createAlarmLog();
        _toggleAlarmDevices(true);
        _setIsDeviceInAlarmState(true);
      }
    } else if (ref.read(isDeviceInAlarmState) && ref.read(shouldWaterGunBeOn)) {
      switch (pressedPressurePlate) {
        case 1:
          _serialService.sendCommand(Commands.waterGunPos1);
          break;
        case 2:
          _serialService.sendCommand(Commands.waterGunPos2);
          break;
        case 3:
          _serialService.sendCommand(Commands.waterGunPos3);
          break;
        case 4:
          _serialService.sendCommand(Commands.waterGunPos4);
          break;
      }
      if (pressedPressurePlate > 0 && pressedPressurePlate <= 4) {
        _databaseService.createWaterGunLog(pressedPressurePlate);
        showToast(
          message:
              'Water Gun has been deployed to Sector $pressedPressurePlate',
          status: Status.warning,
        );
      }
    }
  }

  void _toggleAlarmDevices(bool state) {
    if (state) {
      _serialService.sendCommand(Commands.alarmLightOn);
      _serialService.sendCommand(Commands.buzzerOn);
    } else {
      _serialService.sendCommand(Commands.alarmLightOff);
      _serialService.sendCommand(Commands.buzzerOff);
    }
  }

  void _stopLogging() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  Future<void> _loadFromConfiguration() async {
    final configuration = await DatabaseService().fetchLatestConfiguration();
    _setDistanceAlarmThresholdValue(configuration?.distanceAlarmTrigger ?? 20);
    _setShouldWaterGunBeOnState(configuration?.activateWaterGun ?? false);
  }

  _setIsDeviceConnected(bool state) {
    ref.watch(isDeviceConnected.notifier).state = state;
  }

  _setIsDeviceActive(bool state) {
    ref.watch(isDeviceActive.notifier).state = state;
  }

  _setIsDeviceInAlarmState(bool state) {
    ref.watch(isDeviceInAlarmState.notifier).state = state;
  }

  _setShouldWaterGunBeOnState(bool state) {
    ref.watch(shouldWaterGunBeOn.notifier).state = state;
  }

  _setDistanceAlarmThresholdValue(int value) {
    ref.watch(distanceAlarmThreshold.notifier).state = value;
  }
}
