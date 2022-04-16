import 'dart:async';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/services/serial_service.dart';
import 'package:guardian_app/utils/constants/commands.dart';

final isDeviceConnected = StateProvider((_) => false);
final isDeviceActive = StateProvider((_) => false);

class GuardianService {
  late Ref ref;

  final SerialService _serialService = SerialService();
  Isolate? _isolate;
  ReceivePort? _receivePort;

  GuardianService(this.ref);

  Future<void> connectToDevice() async {
    await _serialService.connectToArduino();
    _setIsDeviceConnected(true);
  }

  Future<void> disconnectDevice() async {
    if (ref.watch(isDeviceConnected)) {
      deactivateDevice();
    }
    await _serialService.disconnectArduino();
    _setIsDeviceConnected(false);
  }

  void activateDevice() {
    _serialService.sendCommand(Commands.handshake);
    _setIsDeviceActive(true);
    _startLogging();
  }

  void deactivateDevice() async {
    _serialService.sendCommand(Commands.disconnect);
    _setIsDeviceActive(false);
    _stopLogging();
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
    int? distance = int.tryParse(
      await _serialService.makeTransaction(
            Commands.getDistance,
          ) ??
          '0',
    );
    int? pressedPressurePlate = int.tryParse(
      await _serialService.makeTransaction(
            Commands.getPressureStatus,
          ) ??
          '-1',
    );
    if (pressedPressurePlate! > 0 && distance! < 20) {
      _serialService.sendCommand(Commands.alarmLightOn);
      // _serialService.sendCommand(Commands.buzzerOn);
      _serialService.sendCommand(Commands.waterGunOn);
      // switch (pressedPressurePlate) {
      //   case 1:
      //     _serialService.sendCommand(Commands.waterGunPos1);
      //     break;
      //   case 2:
      //     _serialService.sendCommand(Commands.waterGunPos2);
      //     break;
      //   case 3:
      //     _serialService.sendCommand(Commands.waterGunPos3);
      //     break;
      //   case 4:
      //     _serialService.sendCommand(Commands.waterGunPos4);
      //     break;
      // }
    } else {
      _serialService.sendCommand(Commands.alarmLightOff);
      // _serialService.sendCommand(Commands.buzzerOff);
      _serialService.sendCommand(Commands.waterGunOff);
    }
  }

  void _stopLogging() {
    if (_isolate != null) {
      _receivePort!.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  _setIsDeviceConnected(bool state) {
    ref.watch(isDeviceConnected.notifier).state = state;
  }

  _setIsDeviceActive(bool state) {
    ref.watch(isDeviceActive.notifier).state = state;
  }
}
